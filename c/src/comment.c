#include "comment.h"
#include <stdlib.h>

static void delete_comment_content(const Comment* comment);

const Comment* Comment_new(Location location, const wchar_t* text) {
    Comment* comment  = (Comment*)malloc(sizeof(Comment));
    comment->comment_delete = (item_delete_function)Comment_delete;
    comment->type = Gherkin_Comment;
    comment->location.line = location.line;
    comment->location.column = location.column;
    comment->text = 0;
    if (text) {
        int length = wcslen(text);
        comment->text = (wchar_t*)malloc((length + 1) * sizeof(wchar_t));
        wmemcpy(comment->text, text, length);
        comment->text[length] = L'\0';
    }
    return comment;
}

void Comment_delete(const Comment* comment) {
    if (!comment) {
        return;
    }
    delete_comment_content(comment);
    free((void*)comment);
}

void Comment_transfer(Comment* to_comment, Comment* from_comment) {
    to_comment->type = from_comment->type;
    to_comment->location.line = from_comment->location.line;
    to_comment->location.column = from_comment->location.column;
    to_comment->text = from_comment->text;
    from_comment->text = 0;
    Comment_delete(from_comment);
}

void Comments_delete(const Comments* comments) {
    if (!comments) {
        return;
    }
    int i;
    for(i = 0; i < comments->comment_count; ++i) {
        delete_comment_content(comments->comments + i);
    }
    free((void*)comments);
}

static void delete_comment_content(const Comment* comment) {
    if (comment->text) {
        free((void*)comment->text);
    }
}
