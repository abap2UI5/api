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
                a = VALUE #( ( `xmlns=sap.m` )
                             ( `xmlns:mvc=sap.ui.core.mvc` )
                             ( `xmlns:form=sap.ui.layout.form` ) )
        )->open( n = `SimpleForm` ns = `form`
                 a = VALUE #( ( `width=auto` )
                              ( `class=sapUiResponsiveMargin` )
                              ( `layout=ResponsiveGridLayout` )
                              ( `editable=true` )
                              ( `labelSpanL=3` )
                              ( `labelSpanM=3` )
                              ( `emptySpanL=4` )
                              ( `emptySpanM=4` )
                              ( `columnsL=1` )
                              ( `columnsM=1` )
                              ( `title=Number Input` ) )
            )->open( n = `content` ns = `form`

                )->leaf( n = `Label`
                         a = VALUE #( ( `text=Number` ) )
                )->leaf( n = `Input`
                         a = VALUE #( ( `value={ path: '` && path && `', type: 'sap.ui.model.type.Integer' }` ) )

            )->shut(
        )->shut(
        )->open( n = `SimpleForm` ns = `form`
                 a = VALUE #( ( `width=auto` )
                              ( `class=sapUiResponsiveMargin` )
                              ( `layout=ResponsiveGridLayout` )
                              ( `labelSpanL=3` )
                              ( `labelSpanM=3` )
                              ( `emptySpanL=4` )
                              ( `emptySpanM=4` )
                              ( `columnsL=1` )
                              ( `columnsM=1` )
                              ( `title=Min Integer Digits (minimal number of non-fraction digits)` ) )
            )->open( n = `content` ns = `form`

                )->leaf( n = `Label`
                         a = VALUE #( ( `text=3 digits` ) )
                )->leaf( n = `Text`
                         a = VALUE #( ( `text={ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { minIntegerDigits: 3 } }` ) )
                )->leaf( n = `Label`
                         a = VALUE #( ( `text=5 digits` ) )
                )->leaf( n = `Text`
                         a = VALUE #( ( `text={ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { minIntegerDigits: 5 } }` ) )

            )->shut(
        )->shut(
        )->open( n = `SimpleForm` ns = `form`
                 a = VALUE #( ( `width=auto` )
                              ( `class=sapUiResponsiveMargin` )
                              ( `layout=ResponsiveGridLayout` )
                              ( `labelSpanL=3` )
                              ( `labelSpanM=3` )
                              ( `emptySpanL=4` )
                              ( `emptySpanM=4` )
                              ( `columnsL=1` )
                              ( `columnsM=1` )
                              ( `title=Max Integer Digits (maximal number of non-fraction digits)` ) )
            )->open( n = `content` ns = `form`

                )->leaf( n = `Label`
                         a = VALUE #( ( `text=2 digits` ) )
                )->leaf( n = `Text`
                         a = VALUE #( ( `text={ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { maxIntegerDigits: 2 } }` ) )
                )->leaf( n = `Label`
                         a = VALUE #( ( `text=5 digits` ) )
                )->leaf( n = `Text`
                         a = VALUE #( ( `text={ path: '` && path && `', type: 'sap.ui.model.type.Integer', formatOptions: { maxIntegerDigits: 5 } }` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
