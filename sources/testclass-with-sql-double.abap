CLASS ltc_test_core_data_service DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    TYPES business_users TYPE STANDARD TABLE OF I_BusinessUserBasic WITH EMPTY KEY.

    CLASS-DATA sql_environment TYPE REF TO if_osql_test_environment.

    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS teardown.

    METHODS prepare_test_data
      IMPORTING business_users TYPE business_users.

    METHODS entry_found FOR TESTING.
    METHODS no_name     FOR TESTING.
    METHODS no_entry    FOR TESTING.
ENDCLASS.

CLASS zcl_bs_demo_deco_usage DEFINITION LOCAL FRIENDS ltc_test_core_data_service.

CLASS ltc_test_core_data_service IMPLEMENTATION.
  METHOD class_setup.
    sql_environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'I_BUSINESSUSERBASIC' ) ) ).
  ENDMETHOD.


  METHOD class_teardown.
    sql_environment->destroy( ).
  ENDMETHOD.


  METHOD prepare_test_data.
    sql_environment->insert_test_data( business_users ).
  ENDMETHOD.


  METHOD teardown.
    sql_environment->clear_doubles(  ).
  ENDMETHOD.


  METHOD entry_found.
    prepare_test_data( VALUE #( ( BusinessPartner = `1`
                                  PersonFullName  = `Ada Lovelace` ) ) ).

    FINAL(cut) = NEW zcl_bs_demo_deco_usage( ).

    FINAL(result) = cut->use_core_data_service( `1` ).

    cl_abap_unit_assert=>assert_equals( exp = `Ada Lovelace`
                                        act = result ).
  ENDMETHOD.


  METHOD no_name.
    prepare_test_data( VALUE #( ( BusinessPartner = `1`
                                  PersonFullName  = `` ) ) ).

    FINAL(cut) = NEW zcl_bs_demo_deco_usage( ).

    FINAL(result) = cut->use_core_data_service( `1` ).

    cl_abap_unit_assert=>assert_initial( result ).
  ENDMETHOD.


  METHOD no_entry.
    prepare_test_data( VALUE #( ( BusinessPartner = `1`
                                  PersonFullName  = `Ada Lovelace` ) ) ).

    FINAL(cut) = NEW zcl_bs_demo_deco_usage( ).

    FINAL(result) = cut->use_core_data_service( `2` ).

    cl_abap_unit_assert=>assert_initial( result ).
  ENDMETHOD.
ENDCLASS.