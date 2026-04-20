CLASS z2ui5_cl_demo_app_305 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.
    TYPES:
      BEGIN OF ty_col,
        header TYPE string,
        color  TYPE string,
      END OF ty_col.
    TYPES:
      BEGIN OF ty_row,
        col1 TYPE string,
        col2 TYPE string,
        col3 TYPE string,
      END OF ty_row.
    DATA t_columns TYPE STANDARD TABLE OF ty_col WITH EMPTY KEY.
    DATA t_tab     TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS set_view.

ENDCLASS.


CLASS z2ui5_cl_demo_app_305 IMPLEMENTATION.

  METHOD set_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
                    )->page(
                      title          = 'abap2UI5 - Tables and column colors'
                      navbuttonpress = client->_event_nav_app_leave( )
                      shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(lv_css) = ``.
    DATA(lv_idx) = 1.
    LOOP AT t_columns INTO DATA(ls_col).
      lv_css = lv_css
        && `td:nth-child(` && lv_idx && `),`
        && `th:nth-child(` && lv_idx && `){`
        && `background-color:` && ls_col-color && `;`
        && `}`.
      lv_idx = lv_idx + 1.
    ENDLOOP.

    page->_generic(
            name = `style`
            ns   = `html`
       )->_cc_plain_xml( lv_css ).

    DATA(tab) = page->table(
            items = client->_bind_edit( t_tab )
            mode  = 'None'
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( 'change column color'
        )->get_parent( )->get_parent( ).

    DATA(cols) = tab->columns( ).
    LOOP AT t_columns INTO ls_col.
      cols->column( )->text( ls_col-header ).
    ENDLOOP.

    tab->items( )->column_list_item(
      )->cells(
        )->text( '{COL1}'
        )->text( '{COL2}'
        )->text( '{COL3}' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      t_columns = VALUE #(
          ( header = 'Title'   color = 'red' )
          ( header = 'Value 1' color = 'blue' )
          ( header = 'Value 2' color = 'green' ) ).

      t_tab = VALUE #(
          ( col1 = 'entry 01'  col2 = 'alpha'  col3 = 'A' )
          ( col1 = 'entry 02'  col2 = 'beta'   col3 = 'B' )
          ( col1 = 'entry 03'  col2 = 'gamma'  col3 = 'C' )
          ( col1 = 'entry 04'  col2 = 'delta'  col3 = 'D' )
          ( col1 = 'entry 05'  col2 = 'eps'    col3 = 'E' )
          ( col1 = 'entry 06'  col2 = 'zeta'   col3 = 'F' ) ).

      set_view( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
