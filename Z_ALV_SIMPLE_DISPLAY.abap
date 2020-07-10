*&---------------------------------------------------------------------*
*& Report  Z_ALV_SIMPLE_DISPLAY
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_alv_simple_display.

TABLES: t100.

DATA: gt_t100 TYPE TABLE OF t100.

*--------------------------------------------------------------------*
* Selection Screen.
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-b01.

SELECT-OPTIONS:
  s_arbgb FOR t100-arbgb OBLIGATORY,
  s_sprsl FOR t100-sprsl OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.

*--------------------------------------------------------------------*
* Start of Selection.
*--------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM get_data.

  PERFORM list_data.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .

  CLEAR gt_t100.

  SELECT *
    FROM  t100
    WHERE
      t100~arbgb IN @s_arbgb AND
      t100~sprsl IN @s_sprsl
    INTO TABLE @gt_t100.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  LIST_DATA
*&---------------------------------------------------------------------*
FORM list_data .

  DATA: lv_gridtitle TYPE lvc_title.

  WRITE lines( gt_t100 ) TO lv_gridtitle.
  CONDENSE lv_gridtitle NO-GAPS.
  CONCATENATE 'ALV Raport for HR Employees, NR OF ROWS:'
              lv_gridtitle
         INTO lv_gridtitle SEPARATED BY space.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program = sy-repid
      i_structure_name   = 'T100'
      i_grid_title       = lv_gridtitle
*     IS_LAYOUT_LVC      =
*     IT_FIELDCAT_LVC    =
    TABLES
      t_outtab           = gt_t100
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

ENDFORM.
