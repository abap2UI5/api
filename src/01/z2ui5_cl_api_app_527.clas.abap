"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Select - Select
"! https://sdk.openui5.org/entity/sap.m.Select/sample/sap.m.sample.Select
CLASS z2ui5_cl_api_app_527 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_s_product.
    DATA t_products  TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA t_products2 TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA t_products3 TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA selected_product  TYPE string.
    DATA selected_product2 TYPE string.
    DATA selected_product3 TYPE string.
    DATA enabled  TYPE abap_bool.
    DATA editable TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS data_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_527 IMPLEMENTATION.

  METHOD data_init.

    " Data of the inline JSON model defined in the original sample controller
    selected_product  = `HT-1001`.
    selected_product2 = `HT-1001`.
    selected_product3 = `HT-1001`.
    enabled  = abap_true.
    editable = abap_true.

    t_products = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15` )
      ( product_id = `HT-1001` name = `Notebook Basic 17` )
      ( product_id = `HT-1002` name = `Notebook Basic 18` )
      ( product_id = `HT-1003` name = `Notebook Basic 19` )
      ( product_id = `HT-1007` name = `ITelO Vault` ) ).

    t_products2 = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15` )
      ( product_id = `HT-1001` name = `Notebook Basic 17` )
      ( product_id = `HT-1002` name = `Notebook Basic 18` )
      ( product_id = `HT-1003` name = `Notebook Basic 19` )
      ( product_id = `HT-1007` name = `ITelO Vault` ) ).

    t_products3 = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15` )
      ( product_id = `HT-1001` name = `Notebook Basic 17` )
      ( product_id = `HT-1002` name = `Notebook Basic 18` )
      ( product_id = `HT-1003` name = `Notebook Basic 19` )
      ( product_id = `HT-1007` name = `ITelO Vault` ) ).

    " the original binds items with a model sorter { path: 'Name' } - the data is sorted in ABAP instead
    SORT t_products  BY name.
    SORT t_products2 BY name.
    SORT t_products3 BY name.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `height`     v = `100%`
        )->attr( n = `xmlns:core` v = `sap.ui.core`
        )->attr( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->attr( n = `xmlns`      v = `sap.m`

        )->open( `Page`
            )->attr( n = `showHeader` v = `false`
            )->attr( n = `class`      v = `sapUiContentPadding`

            )->open( `subHeader`
                )->open( `Toolbar`
                    )->leaf( `ToolbarSpacer`
                    )->open( `Select`
                        )->attr( n = `forceSelection` v = `false`
                        )->attr( n = `selectedKey`    v = client->_bind_edit( selected_product )
                        )->attr( n = `items`          v = client->_bind_edit( t_products )

                        )->leaf( n = `Item` ns = `core`
                            )->attr( n = `key`  v = `{PRODUCT_ID}`
                            )->attr( n = `text` v = `{NAME}`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `content`
                )->open( `HBox`
                    )->attr( n = `justifyContent` v = `SpaceAround`

                    )->open( `Select`
                        )->attr( n = `enabled`        v = client->_bind_edit( enabled )
                        )->attr( n = `editable`       v = client->_bind_edit( editable )
                        )->attr( n = `forceSelection` v = `false`
                        )->attr( n = `selectedKey`    v = client->_bind_edit( selected_product2 )
                        )->attr( n = `items`          v = client->_bind_edit( t_products2 )

                        )->leaf( n = `Item` ns = `core`
                            )->attr( n = `key`  v = `{PRODUCT_ID}`
                            )->attr( n = `text` v = `{NAME}`

                    )->shut(

                    )->open( `VBox`
                        )->open( `HBox`
                            )->attr( n = `alignItems` v = `Center`

                            )->leaf( `Label`
                                )->attr( n = `text`  v = `Enabled:`
                                )->attr( n = `class` v = `sapUiTinyMarginEnd`
                            )->leaf( `Switch`
                                )->attr( n = `type`  v = `AcceptReject`
                                )->attr( n = `state` v = client->_bind_edit( enabled )

                        )->shut(
                        )->open( `HBox`
                            )->attr( n = `alignItems` v = `Center`

                            )->leaf( `Label`
                                )->attr( n = `text`  v = `Editable:`
                                )->attr( n = `class` v = `sapUiTinyMarginEnd`
                            )->leaf( `Switch`
                                )->attr( n = `type`  v = `AcceptReject`
                                )->attr( n = `state` v = client->_bind_edit( editable )

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `footer`
                )->open( `Toolbar`
                    )->leaf( `ToolbarSpacer`
                    )->open( `Select`
                        )->attr( n = `forceSelection`  v = `false`
                        )->attr( n = `selectedKey`     v = client->_bind_edit( selected_product3 )
                        )->attr( n = `type`            v = `IconOnly`
                        )->attr( n = `icon`            v = `sap-icon://filter`
                        )->attr( n = `autoAdjustWidth` v = `true`
                        )->attr( n = `items`           v = client->_bind_edit( t_products3 )

                        )->leaf( n = `Item` ns = `core`
                            )->attr( n = `key`  v = `{PRODUCT_ID}`
                            )->attr( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      data_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
