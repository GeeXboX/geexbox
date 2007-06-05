#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "command.h"
#define MPLAYER_FIFO "/var/mp_control"
#define MPLAYER_DIR "/var/mp_current_path"
#define START_DIR "/mnt"
#define MAX 512

/* toDo
+ replace MAX with size of file in execMplayerCmd and execSystemCmd+
+ return (and check) exit status from execMplayerCmd and execSystemCmd
+ play m3u lists
+ mplayer function: view image
+ mplayer function: play m3u file
*/

/* cmd */
void cmdSystem(const char *cmd) {
	if(cmd != NULL) {
		execSystemCmd(cmd);
	}
}

void cmdMplayer(const char *cmd) {
	if(cmd != NULL) {
		execMplayerCmd(cmd);
	}
}

void mplayerMenu(const char *param) {
	if(param != NULL) {		
		menu(param);
	}
}

/* Mplayer commands */
void playFile(const char *file) {
	if(file != NULL) {
		char cmd[MAX] = "load '";
		strcat(cmd, file);
		strcat(cmd, "'");
		
		execMplayerCmd(cmd);
	}
}

void menu(const char *value) {
	if(value != 0) {
		char param[20];
		sprintf(param, "%s", value); 
		
		char cmd[MAX] = "menu ";
		strcat(cmd, param);
		
		execMplayerCmd(cmd);
	}
}


/* System commands */
void playDir(const char *file) {
	if(file != NULL) {
		char cmd[MAX] = "playdir '";
		strcat(cmd, file);
		strcat(cmd, "'");

		execSystemCmd(cmd);
	}
}


/* Exec functions */
void execMplayerCmd(const char *cmd) {
	char systemcommand[MAX];
	
	snprintf(systemcommand, sizeof(systemcommand), "echo \"%s\" > %s", cmd, MPLAYER_FIFO);
	system(systemcommand);
}

void execSystemCmd(const char *cmd) {
	char systemcommand[MAX];
	
	snprintf(systemcommand, sizeof(systemcommand), "%s", cmd);
	system(systemcommand);
}


/* current dir functions */
const char * getDir() {
	char *path = getFileContent(MPLAYER_DIR);
	
	if(strlen(path) == 0) {
		return START_DIR;
	} else {
		return path;
	}
}

void setDir(const char *data) {
	setFileContent(MPLAYER_DIR, data);
}

const char * getFileContent(const char *path) {
	FILE* file = NULL;
	char *dir;
	char buff[MAX];
	
	
        if(!(file = fopen(path,"r"))) {
		return "";
        } else {
		fgets(buff, MAX, file);
		fclose(file);
		
		dir = (char *)malloc(MAX * sizeof(buff));
		strcpy(dir, buff);
		
		return dir;
	}
}

void setFileContent(const char *path, const char *data) {
	FILE *file = fopen(path, "w");
	fprintf(file, "%s", data);
	fclose(file);
}
