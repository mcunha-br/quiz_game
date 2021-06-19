extends Resource
class_name QuizQuestion

enum QuestionType { TEXT, IMAGE, VIDEO, AUDIO }

export(String) var question_info
export(QuestionType) var type
export(Texture) var question_image
export(AudioStream) var question_audio
export(VideoStream) var question_video
export(Array, String) var options
export(String) var correct
