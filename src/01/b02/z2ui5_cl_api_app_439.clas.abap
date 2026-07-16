CLASS z2ui5_cl_api_app_439 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_439 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(warning_text) = `Warning message. Extra long text used as a warning message. Extra long text used as a warning message - 2. ` &&
                         `Extra long text used as a warning message - 3. Extra long text used as a warning message - 4. ` &&
                         `Extra long text used as a warning message - 5.`.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->leaf( `Input`
                )->a( n = `value` v = `Value state None`
                )->a( n = `class` v = `sapUiSmallMarginTopBottom`

            " showClearIcon="true" omitted - Input property only available since UI5 1.94
            )->leaf( `Input`
                )->a( n = `valueState` v = `Success`
                )->a( n = `value`      v = `Value state Success`
                )->a( n = `class`      v = `sapUiSmallMarginTopBottom`

            )->leaf( `Input`
                )->a( n = `valueState`     v = `Warning`
                )->a( n = `valueStateText` v = warning_text
                )->a( n = `value`          v = `Value state Warning.`
                )->a( n = `class`          v = `sapUiSmallMarginTopBottom`

            " formattedValueStateText (FormattedText with a Link) omitted - only available since UI5 1.78
            )->leaf( `Input`
                )->a( n = `valueState` v = `Warning`
                )->a( n = `value`      v = `Value state Warning with message containing a link.`
                )->a( n = `class`      v = `sapUiSmallMarginTopBottom`

            )->leaf( `Input`
                )->a( n = `valueState` v = `Error`
                )->a( n = `value`      v = `Value state Error`
                )->a( n = `class`      v = `sapUiSmallMarginTopBottom`

            )->leaf( `Input`
                )->a( n = `valueState` v = `Information`
                )->a( n = `value`      v = `Value state Information`
                )->a( n = `class`      v = `sapUiSmallMarginTopBottom`

            " formattedValueStateText (FormattedText with multiple Links) omitted - only available since UI5 1.78
            )->leaf( `Input`
                )->a( n = `valueState` v = `Information`
                )->a( n = `value`      v = `Value state Information with message containing multiple links.`
                )->a( n = `class`      v = `sapUiSmallMarginTopBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
