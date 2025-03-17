CLASS zcl_bs_demo_userapi_int DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES action TYPE c LENGTH 2.
    TYPES role   TYPE c LENGTH 6.

    TYPES: BEGIN OF configuration,
             application_log           TYPE REF TO object,
             cloud_destination         TYPE string,
             communication_arrangement TYPE if_com_management=>ty_cscn_id,
           END OF configuration.

    CONSTANTS: BEGIN OF action_code,
                 create TYPE action VALUE '01',
                 update TYPE action VALUE '02',
                 delete TYPE action VALUE '03',
               END OF action_code.

    CONSTANTS: BEGIN OF partner_role,
                 employee          TYPE role VALUE 'BUP003',
                 contingent_worker TYPE role VALUE 'BBP005',
               END OF partner_role.

    CLASS-METHODS create_employee
      IMPORTING !user         TYPE ZBS_S_DMOCreateUser
                configuration TYPE configuration
      RETURNING VALUE(result) TYPE string.

  PRIVATE SECTION.
    CLASS-METHODS generate_proxy
      IMPORTING configuration TYPE configuration
      RETURNING VALUE(result) TYPE REF TO zbs_dmo_co_manage_business_use
      RAISING   cx_soap_destination_error
                cx_ai_system_fault.

    CLASS-METHODS fill_request_data
      IMPORTING !user         TYPE ZBS_S_DMOCreateUser
      RETURNING VALUE(result) TYPE zbs_dmo_business_user_bundle_m.
ENDCLASS.


CLASS zcl_bs_demo_userapi_int IMPLEMENTATION.
  METHOD create_employee.
    TRY.
        DATA(proxy) = generate_proxy( configuration ).
        DATA(request) = fill_request_data( user ).

        proxy->manage_business_user_in( EXPORTING input  = request
                                        IMPORTING output = DATA(response) ).

        LOOP AT response-business_user_bundle_maintain-business_user INTO DATA(response_log).
          result = response_log-person_id.

          LOOP AT response_log-log-item INTO DATA(item).
            DATA(severity) = SWITCH #( item-severity_code
                                       WHEN '1' THEN if_bali_constants=>c_severity_status
                                       WHEN '2' THEN if_bali_constants=>c_severity_warning
                                       WHEN '3' THEN if_bali_constants=>c_severity_error
                                       ELSE          if_bali_constants=>c_severity_status ).

            configuration-application_log->add_msg_text( id_type = severity
                                                         id_text = item-note ).
          ENDLOOP.
        ENDLOOP.

      CATCH cx_root INTO DATA(error).
        configuration-application_log->add_msg_exc( error ).
    ENDTRY.
  ENDMETHOD.


  METHOD generate_proxy.
    DATA destination TYPE REF TO if_proxy_destination.

    IF configuration-cloud_destination IS NOT INITIAL.
      destination = cl_soap_destination_provider=>create_by_cloud_destination(
          i_name = configuration-cloud_destination ).

    ELSEIF configuration-communication_arrangement IS NOT INITIAL.
      destination = cl_soap_destination_provider=>create_by_comm_arrangement( configuration-communication_arrangement ).

    ELSE.
      RAISE EXCEPTION NEW cx_soap_destination_error( ).
    ENDIF.

    RETURN NEW zbs_dmo_co_manage_business_use( destination = destination ).
  ENDMETHOD.


  METHOD fill_request_data.
    " Documentation: https://help.sap.com/docs/SAP_S4HANA_CLOUD/f1531d40f450474dbf95f0404cb62007/640fb5fa26664a7486de073b1882405c.html?locale=en-US
    INSERT INITIAL LINE INTO TABLE result-business_user_bundle_maintain-business_user REFERENCE INTO DATA(business_user).

    business_user->validity_period            = VALUE #( start_date = cl_abap_context_info=>get_system_date( )
                                                         end_date   = COND #( WHEN user-ValidTo IS NOT INITIAL
                                                                              THEN user-ValidTo
                                                                              ELSE '29991231' ) ).

    business_user->personal_information       = VALUE #( first_name  = user-FirstName
                                                         last_name   = user-LastName
                                                         action_code = action_code-create ).

    business_user->person_external_id         = user-UserID.

    business_user->user                       = VALUE #(
        user_name                  = user-UserID
        validity_period-start_date = business_user->validity_period-start_date
        validity_period-end_date   = business_user->validity_period-end_date
        action_code                = action_code-create ).

    business_user->workplace_information      = VALUE #( email_address = user-EmailAddress
                                                         action_code   = action_code-create ).

    business_user->action_code                = action_code-create.
    business_user->business_partner_role_code = partner_role-employee.
  ENDMETHOD.
ENDCLASS.