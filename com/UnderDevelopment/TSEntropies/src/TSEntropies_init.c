#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
 Check these declarations against the C/Fortran source code.
 */

/* .C calls */
extern void ApEn_Cfun(void *, void *, void *, void *, void *, void *);
extern void SampEn_Cfun(void *, void *, void *, void *, void *, void *);
extern void FastApEn_Cfun(void *, void *, void *, void *, void *, void *);
extern void FastSampEn_Cfun(void *, void *, void *, void *, void *, void *);

static const R_CMethodDef CEntries[] = {
  {"ApEn_Cfun",   (DL_FUNC) &ApEn_Cfun,   6},
  {"SampEn_Cfun", (DL_FUNC) &SampEn_Cfun, 6},
  {"FastApEn_Cfun",   (DL_FUNC) &FastApEn_Cfun,   6},
  {"FastSampEn_Cfun", (DL_FUNC) &FastSampEn_Cfun, 6},
  {NULL, NULL, 0}
};

void R_init_TSEntropies(DllInfo *dll)
{
  R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}

