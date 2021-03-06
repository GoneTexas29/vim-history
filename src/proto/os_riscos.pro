/* os_riscos.c */
extern void mch_write __ARGS((char_u *s, int len));
extern int mch_inchar __ARGS((char_u *buf, int maxlen, long wtime, int tb_change_cnt));
extern int mch_char_avail __ARGS((void));
extern long_u mch_avail_mem __ARGS((int special));
extern void mch_delay __ARGS((long msec, int ignoreinput));
extern void mch_suspend __ARGS((void));
extern void mch_init __ARGS((void));
extern int mch_check_win __ARGS((int argc, char **argv));
extern int mch_input_isatty __ARGS((void));
extern int mch_can_restore_title __ARGS((void));
extern int mch_can_restore_icon __ARGS((void));
extern void mch_settitle __ARGS((char_u *title, char_u *icon));
extern void mch_restore_title __ARGS((int which));
extern int mch_get_user_name __ARGS((char_u *s, int len));
extern void mch_get_host_name __ARGS((char_u *s, int len));
extern long mch_get_pid __ARGS((void));
extern int mch_dirname __ARGS((char_u *buf, int len));
extern int mch_FullName __ARGS((char_u *fname, char_u *buf, int len, int force));
extern int mch_isFullName __ARGS((char_u *fname));
extern long mch_getperm __ARGS((char_u *name));
extern int mch_setperm __ARGS((char_u *name, long perm));
extern void mch_hide __ARGS((char_u *name));
extern int mch_isdir __ARGS((char_u *name));
extern int mch_can_exe __ARGS((char_u *name));
extern int mch_nodetype __ARGS((char_u *name));
extern void mch_early_init __ARGS((void));
extern void mch_exit __ARGS((int r));
extern void mch_settmode __ARGS((int tmode));
extern void mch_setmouse __ARGS((int on));
extern int mch_screenmode __ARGS((char_u *arg));
extern int mch_get_shellsize __ARGS((void));
extern void mch_set_shellsize __ARGS((void));
extern void mch_new_shellsize __ARGS((void));
extern int mch_call_shell __ARGS((char_u *cmd, int options));
extern void mch_breakcheck __ARGS((void));
extern int mch_expandpath __ARGS((garray_T *gap, char_u *path, int flags));
extern int expand_section __ARGS((garray_T *gap, char_u *root, char_u *rest, int flags));
extern int mch_expand_wildcards __ARGS((int num_pat, char_u **pat, int *num_file, char_u ***file, int flags));
extern int mch_has_exp_wildcard __ARGS((char_u *p));
extern int mch_has_wildcard __ARGS((char_u *p));
extern int mch_remove __ARGS((char_u *file));
extern char_u *mch_munge_fname __ARGS((char_u *fname));
extern int ro_buflist_add __ARGS((char_u *old_name));
extern int mch_chdir __ARGS((char_u *dir));
extern void mch_read_filetype __ARGS((char_u *file));
extern void mch_set_filetype __ARGS((char_u *file, char_u *type));
extern int mch_check_filetype __ARGS((char_u *fname, char_u *type));
/* vim: set ft=c : */
