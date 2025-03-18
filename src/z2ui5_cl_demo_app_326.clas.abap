CLASS z2ui5_cl_demo_app_326 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA unit              TYPE meins.
    DATA numc              TYPE /SCWM/TANUM.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS z2ui5_set_data.

    METHODS display_view
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

    METHODS on_event
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

    METHODS convert_value
      IMPORTING
        !value TYPE REF TO data.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_326 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
      z2ui5_set_data( ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    client->view_display( val = view->shell(
           )->page( title          = 'abap2UI5 - Conversion Exit'
                    navbuttonpress = client->_event( 'BACK' )
                    shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
        )->simple_form( title    = 'Form Title'
                        editable = abap_true
                   )->content( 'form'
                       )->title( 'Conversion'
                       )->label( 'Numeric'
                       )->input( value   = client->_bind_edit( numc )
                                 enabled = abap_false
                       )->label( `Unit`
                       )->input( value   = client->_bind_edit( unit )
                                 enabled = abap_false
                       )->stringify( ) ).

  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.

  METHOD z2ui5_set_data.

    unit = 'ST'.   " internal ST -> external PC (if logged in in english)
    numc = 10.     " internal 0000000010 -> external 10

    convert_value( REF #( unit )  ).
    convert_value( REF #( numc )  ).

  ENDMETHOD.

  METHOD convert_value.

    DATA lr_ele TYPE REF TO cl_abap_elemdescr.

    TRY.
        lr_ele ?= cl_abap_structdescr=>describe_by_data( value->* ).

        DATA(obj) = lr_ele->get_ddic_object( ).
      CATCH cx_root.
        RETURN.
    ENDTRY.

    DATA(convexit) = VALUE #( obj[ 1 ]-convexit OPTIONAL ).

    IF convexit IS INITIAL.
      RETURN.
    ENDIF.

    CONCATENATE 'CONVERSION_EXIT_' convexit '_OUTPUT'
                INTO DATA(conex).

    TRY.
        CALL FUNCTION conex
          EXPORTING  input  = value->*
          IMPORTING  output = value->*
          EXCEPTIONS OTHERS = 99.
        IF sy-subrc <> 0.
        ENDIF.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
