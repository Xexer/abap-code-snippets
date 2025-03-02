# RAP - Value Helps

Here you can find code snippets for value helps in RAP (ABAP RESTful Programming Model).

## Include value help

Attaches the value help to a field

```ABAP
@Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_ValueHelpNameVH', element : 'FieldName' } }]
```

## Core Data Service for fixed values

Value Help as Dropdown field.

```ABAP
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Field'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZBC_I_ValueHelpNameVH
  as select from    DDCDS_CUSTOMER_DOMAIN_VALUE(
                      p_domain_name : 'ZBC_DOMAIN_NAME') as Values
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T(
                      p_domain_name : 'ZBC_DOMAIN_NAME') as Texts
      on  Texts.domain_name    = Values.domain_name
      and Texts.value_position = Values.value_position
      and Texts.language       = $session.system_language
{
      @ObjectModel.text.element: [ 'Description' ]
      @UI.textArrangement: #TEXT_ONLY
  key Values.value_low as FieldName,

      @UI.hidden: true
      Texts.text       as Description
}
```

Value Help as normal field.

```ABAP
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Field'
define view entity ZBC_I_ValueHelpNameVH
  as select from    DDCDS_CUSTOMER_DOMAIN_VALUE(
                      p_domain_name : 'ZBC_DOMAIN_NAME') as Values
    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T(
                      p_domain_name : 'ZBC_DOMAIN_NAME') as Texts
      on  Texts.domain_name    = Values.domain_name
      and Texts.value_position = Values.value_position
      and Texts.language       = $session.system_language
{
      @ObjectModel.text.element: [ 'Description' ]
      @UI.textArrangement: #TEXT_ONLY
  key Values.value_low as FieldName,

      @UI.hidden: true
      Texts.text       as Description
}
```