CLASS z2ui5_cl_demo_app_161 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.


    INTERFACES z2ui5_if_app .

    DATA client TYPE REF TO z2ui5_if_client .

    METHODS ui5_display .
    METHODS ui5_event .
    METHODS simple_popup1 .
    METHODS simple_popup2 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_161 IMPLEMENTATION.


  METHOD simple_popup1.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(dialog) = popup->dialog(
            afterclose = client->_event( 'BTN_OK_1ND' )
         )->content( ).

    DATA(content) = dialog->button( text  = `Open 2nd popup`
                                    press = client->_event( 'GOTO_2ND' ) ).

    dialog->get_parent( )->buttons(
                  )->button(
                      text  = 'OK'
                      press = client->_event( 'BTN_OK_1ND' )
                      type  = 'Emphasized' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD simple_popup2.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(dialog) = popup->dialog(
        afterclose = client->_event( 'BTN_OK_2ND' )
         )->content( ).

    DATA(content) = dialog->label( text = 'this is a second popup' ).

    dialog->get_parent( )->buttons(
                  )->button(
                      text  = 'GOTO 1ST POPUP'
                      press = client->_event( 'BTN_OK_2ND' )
                      type  = 'Emphasized' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Popup To Popup'
                navbuttonpress = client->_event( val = 'BACK' )
                shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
           )->button(
            text  = 'Open Popup...'
            press = client->_event( 'POPUP' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_event.

    CASE client->get( )-event.
      WHEN 'GOTO_2ND'.
        simple_popup2( ).

      WHEN 'BTN_OK_2ND'.
        client->popup_destroy( ).
        simple_popup1( ).

      WHEN 'BTN_OK_1ND'.
        client->popup_destroy( ).

      WHEN 'POPUP'.
        simple_popup1( ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_display( ).
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.
ENDCLASS.
