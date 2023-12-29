#include "extension.h"

/**
 * This is called after the initial loading sequence has been processed.
 *
 * @param error        Error message buffer.
 * @param maxlength    Size of error message buffer.
 * @param late         Whether or not the module was loaded after map load.
 * @return             True to succeed loading, false to fail.
 */
bool CExtension::SDK_OnLoad(char *error, size_t err_max, bool late)
{
	smutils->LogMessage(myself, "Loaded %s v%s", SMEXT_CONF_NAME, SMEXT_CONF_VERSION);
	return true;
}

void CExtension::SDK_OnUnload()
{
}

/* Linking extension */
CExtension g_Extension;
SMEXT_LINK(&g_Extension);