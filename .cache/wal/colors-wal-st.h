const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#030305", /* black   */
  [1] = "#B58571", /* red     */
  [2] = "#D09878", /* green   */
  [3] = "#EEDE52", /* yellow  */
  [4] = "#5F779B", /* blue    */
  [5] = "#C6AF9A", /* magenta */
  [6] = "#92B0D3", /* cyan    */
  [7] = "#cee6e6", /* white   */

  /* 8 bright colors */
  [8]  = "#90a1a1",  /* black   */
  [9]  = "#B58571",  /* red     */
  [10] = "#D09878", /* green   */
  [11] = "#EEDE52", /* yellow  */
  [12] = "#5F779B", /* blue    */
  [13] = "#C6AF9A", /* magenta */
  [14] = "#92B0D3", /* cyan    */
  [15] = "#cee6e6", /* white   */

  /* special colors */
  [256] = "#030305", /* background */
  [257] = "#cee6e6", /* foreground */
  [258] = "#cee6e6",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
