"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sdk.openui5.org/entity/sap.m.List/sample/sap.m.sample.ListNoData
"! If the list is empty it indicates this state by displaying a message text.
CLASS z2ui5_cl_api_app_445 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_445 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
                a = VALUE #( ( `xmlns:l=sap.ui.layout` )
                             ( `xmlns:mvc=sap.ui.core.mvc` )
                             ( `xmlns=sap.m` ) )

        )->leaf( n = `List`
                 a = VALUE #( ( `headerText=Products` )
                              ( |noDataText=No products found!\nPlease change your filter settings.| ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
