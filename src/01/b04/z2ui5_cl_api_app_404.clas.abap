"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.FlexBox - FlexBoxNested
"! https://sdk.openui5.org/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNested
"! API USAGE AUDIT: (a) frontend_action (_event_client): NO | (b) event t_arg: NO
"! NOTES (generation):
"! - LIVE-TEST: the original colours .item1..item6 and the h2 headings via a
"!   separate style.css; here it is injected as a core:HTML content attribute
"!   (a style tag, minified - see CAPABILITIES.md). Confirm the flex items
"!   render with their background colours in a running system.
CLASS z2ui5_cl_api_app_404 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_404 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the sample's style.css, injected via a core:HTML content attribute
    " (see CAPABILITIES.md) - placed before the HBox so it is no flex item
    DATA(css) = `<style>.nestedFlexboxes .item1{padding:1rem;background-color:#d1dbbd}` &&
                `.nestedFlexboxes .item2{padding:1rem;background-color:#7D8A2E}` &&
                `.nestedFlexboxes .item3{padding:1rem;background-color:#C9D787}` &&
                `.nestedFlexboxes .item4{padding:1rem;background-color:#FFFFFF}` &&
                `.nestedFlexboxes .item5{padding:1rem;background-color:#FFC0A9}` &&
                `.nestedFlexboxes .item6{padding:1rem;background-color:#FF8598}` &&
                `.nestedFlexboxes h2{color:#32363a}</style>`.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->leaf( n = `HTML` ns = `core`
            )->a( n = `content` v = css

        )->open( `HBox`
            )->a( n = `fitContainer` v = `true`
            )->a( n = `alignItems`   v = `Stretch`
            )->a( n = `class`        v = `sapUiSmallMargin nestedFlexboxes`

            )->open( n = `HTML` ns = `core`
                )->a( n = `content` v = `<h2>1</h2>`

                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `2`
                        )->a( n = `styleClass` v = `item1`

                )->shut(
            )->shut(
            )->open( n = `HTML` ns = `core`
                )->a( n = `content` v = `<h2>2</h2>`

                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `3`
                        )->a( n = `styleClass` v = `item2`

                )->shut(
            )->shut(
            )->open( `VBox`
                )->a( n = `fitContainer` v = `true`

                )->open( `layoutData`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `7`

                )->shut(
                )->open( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<h2>3</h2>`

                    )->open( n = `layoutData` ns = `core`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `5`
                            )->a( n = `styleClass` v = `item3`

                    )->shut(
                )->shut(
                )->open( `HBox`
                    )->a( n = `fitContainer` v = `true`
                    )->a( n = `alignItems`   v = `Stretch`

                    )->open( `layoutData`
                        )->leaf( `FlexItemData`
                            )->a( n = `growFactor` v = `3`

                    )->shut(
                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<h2>4</h2>`

                        )->open( n = `layoutData` ns = `core`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `styleClass` v = `item4`

                        )->shut(
                    )->shut(
                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<h2>5</h2>`

                        )->open( n = `layoutData` ns = `core`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `styleClass` v = `item5`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
            )->open( n = `HTML` ns = `core`
                )->a( n = `content` v = `<h2>6</h2>`

                )->open( n = `layoutData` ns = `core`
                    )->leaf( `FlexItemData`
                        )->a( n = `growFactor` v = `5`
                        )->a( n = `styleClass` v = `item6` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
