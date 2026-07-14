"! Generic UI5 XML view builder - translate a UI5 XML view 1:1 by method
"! chaining. Navigate the tree with:
"!   open  - add a child control/aggregation and DESCEND into it (returns child)
"!   add   - add a child but STAY on the current node (returns the same node)
"!   close - ASCEND to the parent (returns parent)
"!   attr  - set one attribute (returns the same node)
"! Element = n (name), namespace prefix = ns (e.g. `f`, `core`, `l`), attributes
"! = a (table of n/v). The root <mvc:View> and its xmlns declarations are written
"! by hand: pass them to factory( ) as attributes, exactly like a real UI5 view.
CLASS z2ui5_cl_api_xml DEFINITION PUBLIC CREATE PRIVATE.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_s_attr,
        n TYPE string,
        v TYPE string,
      END OF ty_s_attr.
    TYPES ty_t_attr TYPE STANDARD TABLE OF ty_s_attr WITH DEFAULT KEY.

    "! root <mvc:View>; pass its attributes incl. the xmlns declarations, e.g.
    "! factory( VALUE #( ( n = `xmlns` v = `sap.m` )
    "!                   ( n = `xmlns:mvc` v = `sap.ui.core.mvc` ) ) )
    CLASS-METHODS factory
      IMPORTING
        a             TYPE ty_t_attr OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS open
      IMPORTING
        n             TYPE string
        ns            TYPE string OPTIONAL
        a             TYPE ty_t_attr OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS add
      IMPORTING
        n             TYPE string
        ns            TYPE string OPTIONAL
        a             TYPE ty_t_attr OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS attr
      IMPORTING
        n             TYPE string
        v             TYPE string
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS close
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS stringify
      RETURNING
        VALUE(result) TYPE string.

  PROTECTED SECTION.
    TYPES ty_t_node TYPE STANDARD TABLE OF REF TO z2ui5_cl_api_xml WITH DEFAULT KEY.

    DATA name   TYPE string.
    DATA prefix TYPE string.
    DATA t_attr TYPE ty_t_attr.
    DATA t_child TYPE ty_t_node.
    DATA parent TYPE REF TO z2ui5_cl_api_xml.
    DATA root   TYPE REF TO z2ui5_cl_api_xml.

    METHODS elem
      IMPORTING
        n             TYPE string
        ns            TYPE string
        a             TYPE ty_t_attr
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS render
      RETURNING
        VALUE(result) TYPE string.

    METHODS xml_escape
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_xml IMPLEMENTATION.

  METHOD factory.

    result = NEW #( ).
    result->root = result.
    result->name = `View`.
    result->prefix = `mvc`.
    result->t_attr = a.

  ENDMETHOD.


  METHOD elem.

    result = NEW #( ).
    result->root = root.
    result->parent = me.
    result->name = n.
    result->prefix = ns.
    result->t_attr = a.
    APPEND result TO t_child.

  ENDMETHOD.


  METHOD open.

    result = elem( n  = n
                   ns = ns
                   a  = a ).

  ENDMETHOD.


  METHOD add.

    elem( n  = n
          ns = ns
          a  = a ).
    result = me.

  ENDMETHOD.


  METHOD attr.

    APPEND VALUE #( n = n v = v ) TO t_attr.
    result = me.

  ENDMETHOD.


  METHOD close.

    result = parent.

  ENDMETHOD.


  METHOD render.

    DATA(qname) = COND string( WHEN prefix IS INITIAL THEN name ELSE |{ prefix }:{ name }| ).

    DATA(attrs) = ``.
    LOOP AT t_attr INTO DATA(at).
      attrs = |{ attrs } { at-n }="{ xml_escape( at-v ) }"|.
    ENDLOOP.

    IF t_child IS INITIAL.
      result = |<{ qname }{ attrs }/>|.
      RETURN.
    ENDIF.

    DATA(inner) = ``.
    LOOP AT t_child INTO DATA(child).
      inner = |{ inner }{ child->render( ) }|.
    ENDLOOP.
    result = |<{ qname }{ attrs }>{ inner }</{ qname }>|.

  ENDMETHOD.


  METHOD xml_escape.

    result = val.
    result = replace( val = result sub = `&` with = `&amp;` occ = 0 ).
    result = replace( val = result sub = `<` with = `&lt;` occ = 0 ).
    result = replace( val = result sub = `>` with = `&gt;` occ = 0 ).
    result = replace( val = result sub = `"` with = `&quot;` occ = 0 ).

  ENDMETHOD.


  METHOD stringify.

    result = root->render( ).

  ENDMETHOD.

ENDCLASS.
