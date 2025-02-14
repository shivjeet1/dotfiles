static const char norm_fg[] = "#cee6e6";
static const char norm_bg[] = "#030305";
static const char norm_border[] = "#90a1a1";

static const char sel_fg[] = "#cee6e6";
static const char sel_bg[] = "#D09878";
static const char sel_border[] = "#cee6e6";

static const char urg_fg[] = "#cee6e6";
static const char urg_bg[] = "#B58571";
static const char urg_border[] = "#B58571";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
};
