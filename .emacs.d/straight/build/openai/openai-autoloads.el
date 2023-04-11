;;; openai-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:


;;;### (autoloads nil "openai" "openai.el" (0 0 0 0))
;;; Generated autoloads from openai.el

(register-definition-prefixes "openai" '("openai-"))

;;;***

;;;### (autoloads nil "openai-audio" "openai-audio.el" (0 0 0 0))
;;; Generated autoloads from openai-audio.el

(autoload 'openai-audio-create-transcription "openai-audio" "\
Send transcribe audio request.

Argument FILE is audio file to transcribe, in one of these formats: mp3, mp4,
mpeg, mpga, m4a, wav, or webm.  CALLBACK is the execuation after request is
made.

Arguments KEY is global options; however, you can overwrite the value by passing
it in.

The rest of the arugments are optional, please see OpenAI API reference page
for more information.  Arguments here refer to MODEL PROMPT, RESPONSE-FORMAT,
TEMPERATURE, and LANGUAGE.

\(fn FILE CALLBACK &key (KEY openai-key) (MODEL \"whisper-1\") PROMPT RESPONSE-FORMAT TEMPERATURE LANGUAGE)" nil nil)

(autoload 'openai-audio-create-translation "openai-audio" "\
Send translate audio request.

Argument FILE is the audio file to translate, in one of these formats: mp3, mp4,
mpeg, mpga, m4a, wav, or webm. CALLBACK is the execuation after request is made.

Arguments KEY is global options; however, you can overwrite the value by passing
it in.

The rest of the arugments are optional, please see OpenAI API reference page
for more information.  Arguments here refer to MODEL PROMPT, RESPONSE-FORMAT,
and TEMPERATURE.

\(fn FILE CALLBACK &key (KEY openai-key) (MODEL \"whisper-1\") PROMPT RESPONSE-FORMAT TEMPERATURE)" nil nil)

;;;***

;;;### (autoloads nil "openai-chat" "openai-chat.el" (0 0 0 0))
;;; Generated autoloads from openai-chat.el

(autoload 'openai-chat "openai-chat" "\
Send chat request.

Arguments MESSAGES and CALLBACK are required for this type of request.  MESSAGES
is the conversation data.  CALLBACK is the execuation after request is made.

Arguments KEY and USER are global options; however, you can overwrite the value
by passing it in.

The rest of the arugments are optional, please see OpenAI API reference page
for more information.  Arguments here refer to MODEL,  TEMPERATURE, TOP-P, N,
STREAM, STOP, MAX-TOKENS, PRESENCE-PENALTY, FREQUENCY-PENALTY, and LOGIT-BIAS.

\(fn MESSAGES CALLBACK &key (KEY openai-key) (MODEL \"gpt-3.5-turbo\") TEMPERATURE TOP-P N STREAM STOP MAX-TOKENS PRESENCE-PENALTY FREQUENCY-PENALTY LOGIT-BIAS (USER openai-user))" nil nil)

(autoload 'openai-chat-say "openai-chat" "\
Start making a conversation to OpenAI.

This is a ping pong message, so you will only get one response." t nil)

(register-definition-prefixes "openai-chat" '("openai-chat-"))

;;;***

;;;### (autoloads nil "openai-completion" "openai-completion.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from openai-completion.el

(autoload 'openai-completion "openai-completion" "\
Send completion request.

Arguments PROMPT and CALLBACK are required for this type of request.  PROMPT is
either the question or instruction to OpenAI.  CALLBACK is the execuation after
request is made.

Arguments KEY and USER are global options; however, you can overwrite the value
by passing it in.

The rest of the arugments are optional, please see OpenAI API reference page
for more information.  Arguments here refer to MODEL, SUFFIX, MAX-TOKENS,
TEMPERATURE, TOP-P, N, STREAM, LOGPROBS, ECHO, STOP, PRESENCE-PENALTY,
FREQUENCY-PENALTY, BEST-OF, and LOGIT-BIAS.

\(fn PROMPT CALLBACK &key (KEY openai-key) (MODEL \"text-davinci-003\") SUFFIX MAX-TOKENS TEMPERATURE TOP-P N STREAM LOGPROBS ECHO STOP PRESENCE-PENALTY FREQUENCY-PENALTY BEST-OF LOGIT-BIAS (USER openai-user))" nil nil)

(autoload 'openai-completion-select-insert "openai-completion" "\
Send the region to OpenAI and insert the result to the next paragraph.

START and END are selected region boundaries.

\(fn START END)" t nil)

(autoload 'openai-completion-buffer-insert "openai-completion" "\
Send the entire buffer to OpenAI and insert the result to the end of buffer." t nil)

(register-definition-prefixes "openai-completion" '("openai-completion-"))

;;;***

;;;### (autoloads nil "openai-edit" "openai-edit.el" (0 0 0 0))
;;; Generated autoloads from openai-edit.el

(autoload 'openai-edit-prompt "openai-edit" "\
Prompt to ask for edited version." t nil)

;;;***

;;;### (autoloads nil "openai-engine" "openai-engine.el" (0 0 0 0))
;;; Generated autoloads from openai-engine.el

(autoload 'openai-list-engines "openai-engine" "\
List currently available (non-finetuned) models." t nil)

(register-definition-prefixes "openai-engine" '("openai-engine-entries"))

;;;***

;;;### (autoloads nil "openai-file" "openai-file.el" (0 0 0 0))
;;; Generated autoloads from openai-file.el

(autoload 'openai-list-files "openai-file" "\
List files that belong to the user's organization." t nil)

(autoload 'openai-upload-file "openai-file" "\
Prompt to upload the file to OpenAI server for file-tuning." t nil)

(autoload 'openai-delete-file "openai-file" "\
Prompt to select the file and delete it." t nil)

(autoload 'openai-retrieve-file "openai-file" "\
Prompt to select the file and print its' information." t nil)

(autoload 'openai-retrieve-file-content "openai-file" "\
Prompt to select the file and print its' content." t nil)

(register-definition-prefixes "openai-file" '("openai-"))

;;;***

;;;### (autoloads nil "openai-fine-tune" "openai-fine-tune.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from openai-fine-tune.el

(autoload 'openai-list-fine-tunes "openai-fine-tune" "\
List fine-tuning jobs." t nil)

(register-definition-prefixes "openai-fine-tune" '("openai-fine-tune-entries"))

;;;***

;;;### (autoloads nil "openai-image" "openai-image.el" (0 0 0 0))
;;; Generated autoloads from openai-image.el

(autoload 'openai-image-prompt "openai-image" "\
Use PROMPT to ask for image, and display result in a buffer.

\(fn PROMPT)" t nil)

(autoload 'openai-image-edit-prompt "openai-image" "\
Use prompt to ask for image, and display result in a buffer." t nil)

(autoload 'openai-image-variation-prompt "openai-image" "\
Prompt to select an IMAGE file, and display result in a buffer.

\(fn IMAGE)" t nil)

(register-definition-prefixes "openai-image" '("openai-"))

;;;***

;;;### (autoloads nil "openai-model" "openai-model.el" (0 0 0 0))
;;; Generated autoloads from openai-model.el

(autoload 'openai-retrieve-model "openai-model" "\
Retrieves a model instance, providing basic information about the model such
as the owner and permissioning." t nil)

(autoload 'openai-list-models "openai-model" "\
Lists the currently available models, and provides basic information about
each one such as the owner and availability." t nil)

(register-definition-prefixes "openai-model" '("openai-model-entries"))

;;;***

;;;### (autoloads nil nil ("openai-embedding.el" "openai-moderation.el")
;;;;;;  (0 0 0 0))

;;;***

(provide 'openai-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; openai-autoloads.el ends here
