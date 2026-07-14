"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sdk.openui5.org/entity/sap.ui.model.type.Integer/sample/sap.ui.core.sample.TypeInteger
"! Formats and parses only the integer digits. The decimal digits are ignored.
CLASS z2ui5_cl_api_app_508 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA number TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_508 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      number = `123`.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(path) = client->_bind_edit( val  = number
                                     path = abap_true ).

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
                a = VALUE #( ( n = `xmlns`      v = `sap.m` )
                             ( n = `xmlns:mvc`  v = `sap.ui.core.mvc` )
                             ( n = `xmlns:form` v = `sap.ui.layout.form` ) )
        )->open( n = `SimpleForm` ns = `form`
                 a = VALUE #( ( n = `width`      v = `auto` )
                              ( n = `class`      v = `sapUiResponsiveMargin` )
                              ( n = `layout`     v = `ResponsiveGridLayout` )
                              ( n = `editable`   v = `true` )
                              ( n = `labelSpanL` v = `3` )
                              ( n = `labelSpanM` v = `3` )
                              ( n = `emptySpanL` v = `4` )
                              ( n = `emptySpanM` v = `4` )
                              ( n = `columnsL`   v = `1` )
                              ( n = `columnsM`   v = `1` )
                              ( n = `title`      v = `Number Input` ) )
            )->open( n = `content` ns = `form`

                )->leaf( n = `Label`
                         a = VALUE #( ( n = `text` v = `Number` ) )
                )->leaf( n = `Input`
                         a = VALUE #( ( n = `value` v = `{ path: '` && path && `', type: 'sap.ui.model.type.Integer' }` ) )

            )->shut(
        )->shut(
        )->open( n = `SimpleForm` ns = `form`
                 a = VALUE #( ( n = `width`      v = `auto` )
                              ( n = `class`      v = `sapUiResponsiveMargin` )
                              ( n = `layout`     v = `ResponsiveGridLayout` )
                              ( n = `labelSpanL` v = `3` )
                              ( n = `labelSpanM` v = `3` )
                              ( n = `emptySpanL` v = `4` )
                              ( n = `emptySpanM` v = `4` )
                              ( n = `columnsL`   v = `1` )
                              ( n = `columnsM`   v = `1` )
                              ( n = `title`      v = `Min Integer Digits (minimal number of non-fraction digits)` ) )
            )->open( n = `content` ns = `form`

                )->leaf( n = `Label`
                         a = VALUE #( ( n = `text` v = `3 digits` ) )
                )->leaf( n = `Text`
                         a = VALUE #( ( n = `text` v = `{ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { minIntegerDigits: 3 } }` ) )
                )->leaf( n = `Label`
                         a = VALUE #( ( n = `text` v = `5 digits` ) )
                )->leaf( n = `Text`
                         a = VALUE #( ( n = `text` v = `{ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { minIntegerDigits: 5 } }` ) )

            )->shut(
        )->shut(
        )->open( n = `SimpleForm` ns = `form`
                 a = VALUE #( ( n = `width`      v = `auto` )
                              ( n = `class`      v = `sapUiResponsiveMargin` )
                              ( n = `layout`     v = `ResponsiveGridLayout` )
                              ( n = `labelSpanL` v = `3` )
                              ( n = `labelSpanM` v = `3` )
                              ( n = `emptySpanL` v = `4` )
                              ( n = `emptySpanM` v = `4` )
                              ( n = `columnsL`   v = `1` )
                              ( n = `columnsM`   v = `1` )
                              ( n = `title`      v = `Max Integer Digits (maximal number of non-fraction digits)` ) )
            )->open( n = `content` ns = `form`

                )->leaf( n = `Label`
                         a = VALUE #( ( n = `text` v = `2 digits` ) )
                )->leaf( n = `Text`
                         a = VALUE #( ( n = `text` v = `{ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { maxIntegerDigits: 2 } }` ) )
                )->leaf( n = `Label`
                         a = VALUE #( ( n = `text` v = `5 digits` ) )
                )->leaf( n = `Text`
                         a = VALUE #( ( n = `text` v = `{ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { maxIntegerDigits: 5 } }` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
