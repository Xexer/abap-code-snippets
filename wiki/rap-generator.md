# RAP - Generator

Here you can find code snippets for the use of the RAP Generators.

## Mandatory fields

Fields you always need in the ROOT entity for the RAP Generator (UI or Business Configuration).

```ABAP
local_created_by      : abp_creation_user;
local_created_at      : abp_creation_tstmpl;
local_last_changed_by : abp_locinst_lastchange_user;
local_last_changed_at : abp_locinst_lastchange_tstmpl;
last_changed_at       : abp_lastchange_tstmpl;
```

If you add the fields later in your entity you have to normalize them.

```ABAP
@Semantics.user.createdBy: true
local_created_by      as LocalCreatedBy,
@Semantics.systemDateTime.createdAt: true
local_created_at      as LocalCreatedAt,
@Semantics.user.localInstanceLastChangedBy: true
local_last_changed_by as LocalLastChangedBy,
@Semantics.systemDateTime.localInstanceLastChangedAt: true
local_last_changed_at as LocalLastChangedAt,
@Semantics.systemDateTime.lastChangedAt: true
last_changed_at       as LastChangedAt
```

When you want to use the fields in a CDS Aspect.

```ABAP
@Semantics.user.createdBy: true
LocalCreatedBy     : abp_creation_user;
@Semantics.systemDateTime.createdAt: true
LocalCreatedAt     : abp_creation_tstmpl;
@Semantics.user.localInstanceLastChangedBy: true
LocalLastChangedBy : abp_locinst_lastchange_user;
@Semantics.systemDateTime.localInstanceLastChangedAt: true
LocalLastChangedAt : abp_locinst_lastchange_tstmpl;
@Semantics.systemDateTime.lastChangedAt: true
LastChangedAt      : abp_lastchange_tstmpl;
```

## Extend with new entity

After generation, you want to extend the data model with another entity. 

### Root

Extend the behavior definition.

```ABAP
define behavior for ZBC_I_Child alias Child
persistent table zbc_child
draft table zbc_child_d
lock dependent by _Parent
authorization dependent by _Parent
{
  field ( mandatory : create, readonly : update ) LocalKey;
  field ( readonly ) SecondaryKey;

  update;
  delete;

  association _Parent { with draft; }

  mapping for zbc_child
    {
      LocalKey = local_key;
    }
}
```

Add the assoziation for creation to the ROOT definition.

```ABAP
association _Child { create; with draft; }
```

### Consumption

Extend the behavior definition.

```ABAP
define behavior for ZBC_C_Child alias Child
use etag
{
  use update;
  use delete;

  use association _Parent { with draft; }
}
```

Add the assoziation for creation to the ROOT entity.

```ABAP
use association _Child { create; with draft; }
```
