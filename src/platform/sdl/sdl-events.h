#ifndef SDL_EVENTS_H
#define SDL_EVENTS_H

#include "gba-thread.h"

#include <SDL.h>

struct GBASDLEvents {
	SDL_Joystick* joystick;
#if SDL_VERSION_ATLEAST(2, 0, 0)
	SDL_Window* window;
	int fullscreen;
#endif
};

int GBASDLInitEvents(struct GBASDLEvents*);
void GBASDLDeinitEvents(struct GBASDLEvents*);

void GBASDLHandleEvent(struct GBAThread* context, struct GBASDLEvents* sdlContext, const union SDL_Event* event);

#endif
