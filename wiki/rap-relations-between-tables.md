# RAP - Relations

Here you can find code snippets for relations in RAP (ABAP RESTful Programming Model).

## Root -> Child

Interface layer (header)

```ABAP
composition of exact one to many ZBC_I_Child as _Child
```

Projection layer (fields)

```ABAP
_Child : redirected to composition child ZBC_C_Child
```

## Child -> Root

Interface layer (header)

```ABAP
association to parent ZBC_R_Parent as _Parent on _Parent.Key = $projection.Key
```

Projection layer (fields)

```ABAP
_Parent : redirected to parent ZBC_C_Parent,
```