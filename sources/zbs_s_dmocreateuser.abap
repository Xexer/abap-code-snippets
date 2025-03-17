@EndUserText.label: 'Create User in System'
define abstract entity ZBS_S_DMOCreateUser
{
  UserID        : abap.string(0);
  FirstName     : abap.char(150);
  LastName      : abap.char(150);
  EMailAddress  : abap.char(250);
  ValidTo       : abap.dats;
}