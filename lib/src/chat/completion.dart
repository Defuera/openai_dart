import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cancellation_token_http/http.dart' as http;

import '../client.dart';

part 'completion.freezed.dart';
part 'completion.g.dart';

@freezed
class ChatChoice with _$ChatChoice {
  const factory ChatChoice({
    /// The index of the choice in the list of choices.
    required int index,

    ///A chat completion message generated by the model.
    ChatMessage? message,
    ChatChoiceDelta? delta,

    /// The reason the model stopped generating tokens. This will be `stop` if
    /// the model hit a natural stop point or a provided stop sequence,
    /// length if the maximum number of tokens specified in the request was
    /// reached, `content_filter` if content was omitted due to a flag from our
    /// content filters, `tool_calls` if the model called a tool,
    /// or `function_call` (deprecated) if the model called a function.
    String? finishReason,
    FinishDetails? finishDetails,
  }) = _ChatChoice;

  factory ChatChoice.fromJson(Map<String, Object?> json) =>
      _$ChatChoiceFromJson(json);
}

@freezed
class FinishDetails with _$FinishDetails {
  const factory FinishDetails({
    required String type,
  }) = _FinishDetails;

  factory FinishDetails.fromJson(Map<String, Object?> json) =>
      _$FinishDetailsFromJson(json);
}

@freezed
class ChatChoiceDelta with _$ChatChoiceDelta {
  const factory ChatChoiceDelta({
    String? content,
    String? role,
    List<MessageToolCall>? toolCalls,
  }) = _ChatChoiceDelta;

  factory ChatChoiceDelta.fromJson(Map<String, Object?> json) =>
      _$ChatChoiceDeltaFromJson(json);
}

/// ChatCompletionRequest is the request body for the chat completion endpoint.
@freezed
class ChatCompletionRequest with _$ChatCompletionRequest {
  const factory ChatCompletionRequest({
    /// ID of the model to use. See the
    /// [model endpoint compatibility table](https://platform.openai.com/docs/models/model-endpoint-compatibility)
    /// for details on which models work with the Chat API.
    required String model,

    /// The messages to generate chat completions for, in the [chat format](https://platform.openai.com/docs/guides/chat/introduction).
    required List<dynamic> messages,

    /// A list of functions the model may generate JSON inputs for.
    @Deprecated("Use tools instead") List<ChatFunction>? functions,

    ///Controls how the model responds to function calls. "none" means the model
    ///does not call a function, and responds to the end-user. "auto" means
    ///the model can pick between an end-user or calling a function.
    ///Specifying a particular function via {"name":\ "my_function"} forces
    ///the model to call that function. "none" is the default when no functions
    ///are present. "auto" is the default if functions are present.
    @Deprecated("use toolChoice instead") dynamic functionCall,

    /// The sampling temperature. Defaults to 1.
    /// What sampling temperature to use, between 0 and 2. Higher values l
    /// ike 0.8 will make the output more random, while lower values like 0.2
    /// will make it more focused and deterministic.
    ///
    /// We generally recommend altering this or [topP] but not both.
    double? temperature,

    /// The top-p sampling parameter. Defaults to 1.
    /// An alternative to sampling with temperature, called nucleus sampling,
    /// where the model considers the results of the tokens with top_p
    /// probability mass. So 0.1 means only the tokens comprising the top 10%
    /// probability mass are considered.
    ///
    /// We generally recommend altering this or [temperature] but not both.
    double? topP,

    /// How many chat completion choices to generate for each input message.
    /// Defaults to 1.
    int? n,

    /// If set, partial message deltas will be sent, like in ChatGPT.
    /// Tokens will be sent as data-only server-sent events as they
    /// become available, with the stream terminated by a data: [DONE] message.
    /// See the OpenAI Cookbook for example code. Defaults to false.
    bool? stream,

    /// Up to 4 sequences where the API will stop generating further tokens.
    /// Defaults to null
    List<String>? stop,

    /// The maximum number of tokens to generate in the chat completion.
    ///  defaults to inf.
    /// The total length of input tokens and generated tokens is limited by the
    ///  model's context length.
    int? maxTokens,

    /// Number between -2.0 and 2.0. Positive values penalize new tokens
    /// based on whether they appear in the text so far, increasing the model's
    /// likelihood to talk about new topics.
    double? presencePenalty,

    /// Number between -2.0 and 2.0. Positive values penalize new tokens
    /// based on whether they appear in the text so far, increasing the
    /// model's likelihood to talk about new topics.
    double? frequencyPenalty,

    /// Modify the likelihood of specified tokens appearing in the completion.
    /// Defaults to null.
    ///  Accepts a json object that maps tokens (specified by their token ID in
    /// the tokenizer) to an associated bias value from -100 to 100.
    /// Mathematically, the bias is added to the logits generated by the model
    /// prior to sampling. The exact effect will vary per model, but values
    ///  between -1 and 1 should decrease or increase likelihood of selection;
    ///  values like -100 or 100 should result in a ban or exclusive selection
    /// of the relevant token.
    Map<String, dynamic>? logitBias,

    /// A list of tools the model may call. Currently,
    /// only functions are supported as a tool. Use this to provide a list of
    /// functions the model may generate JSON inputs for.
    List<ChatTool>? tools,

    /// Controls which (if any) function is called by the model. `none` means the
    /// model will not call a function and instead generates a message.
    /// `auto` means the model can pick between generating a message or calling
    /// a function. Specifying a particular function via
    ///  `{"type: "function", "function": {"name": "my_function"}}` forces the
    ///  model to call that function.
    /// `none` is the default when no functions are present. `auto` is the
    /// default if functions are present.
    dynamic toolChoice,

    /// A unique identifier representing your end-user, which can help OpenAI to
    /// monitor and detect abuse. Learn more.
    String? user,
  }) = _ChatCompletionRequest;

  factory ChatCompletionRequest.fromJson(Map<String, Object?> json) =>
      _$ChatCompletionRequestFromJson(json);
}

@freezed
class ToolChoice with _$ToolChoice {
  const factory ToolChoice({String? type, ChatFunction? function}) =
      _ToolChoice;

  factory ToolChoice.fromJson(Map<String, Object?> json) =>
      _$ToolChoiceFromJson(json);
}

@freezed
class ChatTool with _$ChatTool {
  const factory ChatTool({
    /// The type of the tool. Currently, only `function` is supported.
    required String type,
    required ChatFunction function,
  }) = _ChatTool;

  factory ChatTool.fromJson(Map<String, Object?> json) =>
      _$ChatToolFromJson(json);
}

/// ChatCompletionResponse is the response body for the chat completion endpoint.
/// ```json
/// {
///   "id": "chatcmpl-123",
///   "object": "chat.completion",
///   "created": 1677652288,
///   "choices": [{
///     "index": 0,
///     "message": {
///       "role": "assistant",
///       "content": "\n\nHello there, how may I assist you today?",
///     },
///     "finish_reason": "stop"
///   }],
///   "usage": {
///     "prompt_tokens": 9,
///     "completion_tokens": 12,
///     "total_tokens": 21
///   }
/// }
/// ```
@freezed
class ChatCompletionResponse with _$ChatCompletionResponse {
  const factory ChatCompletionResponse({
    /// The list of choices for the completion.
    required List<ChatChoice> choices,

    /// The ID of the completion.
    required String id,

    /// The object type, which is always `chat.completion`.
    required String object,

    /// The time the completion was created.
    required int created,

    /// This fingerprint represents the backend configuration that the model runs with.
    /// Can be used in conjunction with the seed request parameter to understand when backend
    String? systemFingerprint,

    /// The usage statistics for the completion.
    ChatCompletionUsage? usage,
  }) = _ChatCompletionResponse;

  factory ChatCompletionResponse.fromJson(Map<String, Object?> json) =>
      _$ChatCompletionResponseFromJson(json);
}

@freezed
class ChatCompletionUsage with _$ChatCompletionUsage {
  const factory ChatCompletionUsage({
    /// The number of tokens used for the prompt.
    required int promptTokens,

    /// The number of tokens generated for the completion.
    required int completionTokens,

    /// The total number of tokens used for the prompt and completion.
    required int totalTokens,
  }) = _ChatCompletionUsage;

  factory ChatCompletionUsage.fromJson(Map<String, Object?> json) =>
      _$ChatCompletionUsageFromJson(json);
}

@freezed
@Deprecated(
    "use UserMessage, AssistantMessage, ToolMessage, SystemMessage instead")
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    /// The contents of the message. content is required for all messages except
    /// assistant messages with function calls.
    String? content,

    ///The name of the author of this message. name is **required** if role is
    ///function, and it should be the name of the function whose response is in
    ///the content. May contain a-z, A-Z, 0-9, and underscores, with a maximum
    ///length of 64 characters.
    String? name,

    /// The role of the messages author. One of [ChatMessageRole.system],
    /// [ChatMessageRole.user], [ChatMessageRole.assistant], or [ChatMessageRole.function]
    required ChatMessageRole role,

    /// The tool calls generated by the model, such as function calls.
    List<MessageToolCall>? toolCalls,

    /// The name and arguments of a function that should be called, as generated by the model.
    @Deprecated("Use toolCalls instead") dynamic functionCall,
  }) = _ChatMessage;
  factory ChatMessage.fromJson(Map<String, Object?> json) =>
      _$ChatMessageFromJson(json);
}

@freezed
class MessageToolCall with _$MessageToolCall {
  const factory MessageToolCall({
    int? index,

    /// The ID of the tool call.
    required String id,

    /// The type of the tool. Currently, only function is supported.
    required String type,

    /// The function that the model called.
    required ChatFunctionCall function,
  }) = _MessageToolCall;

  factory MessageToolCall.fromJson(Map<String, Object?> json) =>
      _$MessageToolCallFromJson(json);
}

@freezed
class ChatFunctionCall with _$ChatFunctionCall {
  const factory ChatFunctionCall({
    /// The name of the function to call.
    required String name,

    /// The arguments to call the function with, as generated by the model in
    /// JSON format. Note that the model does not always generate valid JSON,
    /// and may hallucinate parameters not defined by your function schema.
    /// Validate the arguments in your code before calling your function.
    required Map<String, dynamic> arguments,
  }) = _ChatFunctionCall;
  factory ChatFunctionCall.fromJson(Map<String, Object?> json) =>
      _$ChatFunctionCallFromJson(json);
}

@freezed
class ChatFunction with _$ChatFunction {
  const factory ChatFunction({
    /// The name of the function to be called. Must be a-z, A-Z, 0-9,
    /// or contain underscores and dashes, with a maximum length of 64.
    required String name,

    /// The description of what the function does.
    String? description,

    /// The parameters the functions accepts, described as a JSON Schema object.
    /// See the [guide](https://platform.openai.com/docs/guides/gpt/function-calling) for examples, and the [JSON Schema reference](https://json-schema.org/understanding-json-schema/) for
    /// documentation about the format.
    /// To describe a function that accepts no parameters, provide
    /// the value {"type": "object", "properties": {}}.
    ///
    ///```python
    /// response = openai.ChatCompletion.create(
    ///     model="gpt-3.5-turbo-0613",
    ///     messages=[{"role": "user", "content": "What's the weather like in Boston?"}],
    ///     functions=[
    ///         {
    ///             "name": "get_current_weather",
    ///             "description": "Get the current weather in a given location",
    ///             "parameters": {
    ///                 "type": "object",
    ///                 "properties": {
    ///                     "location": {
    ///                         "type": "string",
    ///                         "description": "The city and state, e.g. San Francisco, CA",
    ///                     },
    ///                     "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]},
    ///                 },
    ///                 "required": ["location"],
    ///             },
    ///         }
    ///     ],
    ///     function_call="auto",
    /// )
    /// ```
    ChatFunctionParameters? parameters,
  }) = _ChatFunction;

  factory ChatFunction.fromJson(Map<String, Object?> json) =>
      _$ChatFunctionFromJson(json);
}

@freezed
class ChatFunctionParameters with _$ChatFunctionParameters {
  const factory ChatFunctionParameters({
    @Default("object") String type,
    @Default({}) Map<String, dynamic> properties,
    @Default([]) List<String> required,
  }) = _ChatFunctionParameters;

  factory ChatFunctionParameters.fromJson(Map<String, Object?> json) =>
      _$ChatFunctionParametersFromJson(json);
}

@JsonEnum(valueField: "role")
enum ChatMessageRole {
  system("system"),
  assistant("assistant"),
  @Deprecated("Use tool instead")
  function("function"),
  tool("tool"),
  user("user");

  final String role;
  const ChatMessageRole(this.role);
}

extension ChatCompletion on OpenaiClient {
  static const kEndpoint = "chat/completions";
  Future<ChatCompletionResponse> sendChatCompletion(
    ChatCompletionRequest request, {
    http.CancellationToken? cancellationToken,
  }) async {
    final data = await sendRequest(
      ChatCompletion.kEndpoint,
      request,
      cancellationToken: cancellationToken,
    );
    return ChatCompletionResponse.fromJson(data);
  }

  Future sendChatCompletionStream(
    ChatCompletionRequest request, {
    Function(ChatCompletionResponse)? onSuccess,
    http.CancellationToken? cancellationToken,
  }) async {
    return sendStreamRequest(
      ChatCompletion.kEndpoint,
      jsonEncode(request),
      onSuccess: (data) =>
          onSuccess?.call(ChatCompletionResponse.fromJson(data)),
      cancellationToken: cancellationToken,
    );
  }
}
