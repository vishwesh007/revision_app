// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeckModel _$DeckModelFromJson(Map<String, dynamic> json) {
  return _DeckModel.fromJson(json);
}

/// @nodoc
mixin _$DeckModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get questionCount => throw _privateConstructorUsedError;
  int get dueCount => throw _privateConstructorUsedError;

  /// Serializes this DeckModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeckModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeckModelCopyWith<DeckModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeckModelCopyWith<$Res> {
  factory $DeckModelCopyWith(DeckModel value, $Res Function(DeckModel) then) =
      _$DeckModelCopyWithImpl<$Res, DeckModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      DateTime createdAt,
      int questionCount,
      int dueCount});
}

/// @nodoc
class _$DeckModelCopyWithImpl<$Res, $Val extends DeckModel>
    implements $DeckModelCopyWith<$Res> {
  _$DeckModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeckModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? createdAt = null,
    Object? questionCount = null,
    Object? dueCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      questionCount: null == questionCount
          ? _value.questionCount
          : questionCount // ignore: cast_nullable_to_non_nullable
              as int,
      dueCount: null == dueCount
          ? _value.dueCount
          : dueCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeckModelImplCopyWith<$Res>
    implements $DeckModelCopyWith<$Res> {
  factory _$$DeckModelImplCopyWith(
          _$DeckModelImpl value, $Res Function(_$DeckModelImpl) then) =
      __$$DeckModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      DateTime createdAt,
      int questionCount,
      int dueCount});
}

/// @nodoc
class __$$DeckModelImplCopyWithImpl<$Res>
    extends _$DeckModelCopyWithImpl<$Res, _$DeckModelImpl>
    implements _$$DeckModelImplCopyWith<$Res> {
  __$$DeckModelImplCopyWithImpl(
      _$DeckModelImpl _value, $Res Function(_$DeckModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeckModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? createdAt = null,
    Object? questionCount = null,
    Object? dueCount = null,
  }) {
    return _then(_$DeckModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      questionCount: null == questionCount
          ? _value.questionCount
          : questionCount // ignore: cast_nullable_to_non_nullable
              as int,
      dueCount: null == dueCount
          ? _value.dueCount
          : dueCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeckModelImpl implements _DeckModel {
  const _$DeckModelImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.createdAt,
      this.questionCount = 0,
      this.dueCount = 0});

  factory _$DeckModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeckModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int questionCount;
  @override
  @JsonKey()
  final int dueCount;

  @override
  String toString() {
    return 'DeckModel(id: $id, title: $title, description: $description, createdAt: $createdAt, questionCount: $questionCount, dueCount: $dueCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeckModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.questionCount, questionCount) ||
                other.questionCount == questionCount) &&
            (identical(other.dueCount, dueCount) ||
                other.dueCount == dueCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, description, createdAt, questionCount, dueCount);

  /// Create a copy of DeckModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeckModelImplCopyWith<_$DeckModelImpl> get copyWith =>
      __$$DeckModelImplCopyWithImpl<_$DeckModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeckModelImplToJson(
      this,
    );
  }
}

abstract class _DeckModel implements DeckModel {
  const factory _DeckModel(
      {required final String id,
      required final String title,
      required final String description,
      required final DateTime createdAt,
      final int questionCount,
      final int dueCount}) = _$DeckModelImpl;

  factory _DeckModel.fromJson(Map<String, dynamic> json) =
      _$DeckModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get createdAt;
  @override
  int get questionCount;
  @override
  int get dueCount;

  /// Create a copy of DeckModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeckModelImplCopyWith<_$DeckModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) {
  return _QuestionModel.fromJson(json);
}

/// @nodoc
mixin _$QuestionModel {
  String get id => throw _privateConstructorUsedError;
  String get deckId => throw _privateConstructorUsedError;
  QuestionType get type => throw _privateConstructorUsedError;
  String get prompt => throw _privateConstructorUsedError;
  List<ChoiceModel> get choices => throw _privateConstructorUsedError;
  String get metadata => throw _privateConstructorUsedError;
  ReviewModel? get lastReview => throw _privateConstructorUsedError;

  /// Serializes this QuestionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionModelCopyWith<QuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionModelCopyWith<$Res> {
  factory $QuestionModelCopyWith(
          QuestionModel value, $Res Function(QuestionModel) then) =
      _$QuestionModelCopyWithImpl<$Res, QuestionModel>;
  @useResult
  $Res call(
      {String id,
      String deckId,
      QuestionType type,
      String prompt,
      List<ChoiceModel> choices,
      String metadata,
      ReviewModel? lastReview});

  $ReviewModelCopyWith<$Res>? get lastReview;
}

/// @nodoc
class _$QuestionModelCopyWithImpl<$Res, $Val extends QuestionModel>
    implements $QuestionModelCopyWith<$Res> {
  _$QuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deckId = null,
    Object? type = null,
    Object? prompt = null,
    Object? choices = null,
    Object? metadata = null,
    Object? lastReview = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deckId: null == deckId
          ? _value.deckId
          : deckId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _value.choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<ChoiceModel>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as String,
      lastReview: freezed == lastReview
          ? _value.lastReview
          : lastReview // ignore: cast_nullable_to_non_nullable
              as ReviewModel?,
    ) as $Val);
  }

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReviewModelCopyWith<$Res>? get lastReview {
    if (_value.lastReview == null) {
      return null;
    }

    return $ReviewModelCopyWith<$Res>(_value.lastReview!, (value) {
      return _then(_value.copyWith(lastReview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionModelImplCopyWith<$Res>
    implements $QuestionModelCopyWith<$Res> {
  factory _$$QuestionModelImplCopyWith(
          _$QuestionModelImpl value, $Res Function(_$QuestionModelImpl) then) =
      __$$QuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String deckId,
      QuestionType type,
      String prompt,
      List<ChoiceModel> choices,
      String metadata,
      ReviewModel? lastReview});

  @override
  $ReviewModelCopyWith<$Res>? get lastReview;
}

/// @nodoc
class __$$QuestionModelImplCopyWithImpl<$Res>
    extends _$QuestionModelCopyWithImpl<$Res, _$QuestionModelImpl>
    implements _$$QuestionModelImplCopyWith<$Res> {
  __$$QuestionModelImplCopyWithImpl(
      _$QuestionModelImpl _value, $Res Function(_$QuestionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deckId = null,
    Object? type = null,
    Object? prompt = null,
    Object? choices = null,
    Object? metadata = null,
    Object? lastReview = freezed,
  }) {
    return _then(_$QuestionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deckId: null == deckId
          ? _value.deckId
          : deckId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      choices: null == choices
          ? _value._choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<ChoiceModel>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as String,
      lastReview: freezed == lastReview
          ? _value.lastReview
          : lastReview // ignore: cast_nullable_to_non_nullable
              as ReviewModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionModelImpl implements _QuestionModel {
  const _$QuestionModelImpl(
      {required this.id,
      required this.deckId,
      required this.type,
      required this.prompt,
      required final List<ChoiceModel> choices,
      this.metadata = '{}',
      this.lastReview})
      : _choices = choices;

  factory _$QuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String deckId;
  @override
  final QuestionType type;
  @override
  final String prompt;
  final List<ChoiceModel> _choices;
  @override
  List<ChoiceModel> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  @JsonKey()
  final String metadata;
  @override
  final ReviewModel? lastReview;

  @override
  String toString() {
    return 'QuestionModel(id: $id, deckId: $deckId, type: $type, prompt: $prompt, choices: $choices, metadata: $metadata, lastReview: $lastReview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deckId, deckId) || other.deckId == deckId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            (identical(other.lastReview, lastReview) ||
                other.lastReview == lastReview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, deckId, type, prompt,
      const DeepCollectionEquality().hash(_choices), metadata, lastReview);

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      __$$QuestionModelImplCopyWithImpl<_$QuestionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionModelImplToJson(
      this,
    );
  }
}

abstract class _QuestionModel implements QuestionModel {
  const factory _QuestionModel(
      {required final String id,
      required final String deckId,
      required final QuestionType type,
      required final String prompt,
      required final List<ChoiceModel> choices,
      final String metadata,
      final ReviewModel? lastReview}) = _$QuestionModelImpl;

  factory _QuestionModel.fromJson(Map<String, dynamic> json) =
      _$QuestionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get deckId;
  @override
  QuestionType get type;
  @override
  String get prompt;
  @override
  List<ChoiceModel> get choices;
  @override
  String get metadata;
  @override
  ReviewModel? get lastReview;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChoiceModel _$ChoiceModelFromJson(Map<String, dynamic> json) {
  return _ChoiceModel.fromJson(json);
}

/// @nodoc
mixin _$ChoiceModel {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

  /// Serializes this ChoiceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChoiceModelCopyWith<ChoiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChoiceModelCopyWith<$Res> {
  factory $ChoiceModelCopyWith(
          ChoiceModel value, $Res Function(ChoiceModel) then) =
      _$ChoiceModelCopyWithImpl<$Res, ChoiceModel>;
  @useResult
  $Res call({String id, String text, bool isCorrect, bool isSelected});
}

/// @nodoc
class _$ChoiceModelCopyWithImpl<$Res, $Val extends ChoiceModel>
    implements $ChoiceModelCopyWith<$Res> {
  _$ChoiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isCorrect = null,
    Object? isSelected = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChoiceModelImplCopyWith<$Res>
    implements $ChoiceModelCopyWith<$Res> {
  factory _$$ChoiceModelImplCopyWith(
          _$ChoiceModelImpl value, $Res Function(_$ChoiceModelImpl) then) =
      __$$ChoiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String text, bool isCorrect, bool isSelected});
}

/// @nodoc
class __$$ChoiceModelImplCopyWithImpl<$Res>
    extends _$ChoiceModelCopyWithImpl<$Res, _$ChoiceModelImpl>
    implements _$$ChoiceModelImplCopyWith<$Res> {
  __$$ChoiceModelImplCopyWithImpl(
      _$ChoiceModelImpl _value, $Res Function(_$ChoiceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isCorrect = null,
    Object? isSelected = null,
  }) {
    return _then(_$ChoiceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChoiceModelImpl implements _ChoiceModel {
  const _$ChoiceModelImpl(
      {required this.id,
      required this.text,
      required this.isCorrect,
      this.isSelected = false});

  factory _$ChoiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChoiceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  @override
  final bool isCorrect;
  @override
  @JsonKey()
  final bool isSelected;

  @override
  String toString() {
    return 'ChoiceModel(id: $id, text: $text, isCorrect: $isCorrect, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChoiceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, isCorrect, isSelected);

  /// Create a copy of ChoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChoiceModelImplCopyWith<_$ChoiceModelImpl> get copyWith =>
      __$$ChoiceModelImplCopyWithImpl<_$ChoiceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChoiceModelImplToJson(
      this,
    );
  }
}

abstract class _ChoiceModel implements ChoiceModel {
  const factory _ChoiceModel(
      {required final String id,
      required final String text,
      required final bool isCorrect,
      final bool isSelected}) = _$ChoiceModelImpl;

  factory _ChoiceModel.fromJson(Map<String, dynamic> json) =
      _$ChoiceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get text;
  @override
  bool get isCorrect;
  @override
  bool get isSelected;

  /// Create a copy of ChoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChoiceModelImplCopyWith<_$ChoiceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) {
  return _ReviewModel.fromJson(json);
}

/// @nodoc
mixin _$ReviewModel {
  String get id => throw _privateConstructorUsedError;
  String get questionId => throw _privateConstructorUsedError;
  DateTime get reviewedAt => throw _privateConstructorUsedError;
  int get quality => throw _privateConstructorUsedError;
  int get interval => throw _privateConstructorUsedError;
  int get repetition => throw _privateConstructorUsedError;
  double get easiness => throw _privateConstructorUsedError;
  DateTime get nextReview => throw _privateConstructorUsedError;

  /// Serializes this ReviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewModelCopyWith<ReviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewModelCopyWith<$Res> {
  factory $ReviewModelCopyWith(
          ReviewModel value, $Res Function(ReviewModel) then) =
      _$ReviewModelCopyWithImpl<$Res, ReviewModel>;
  @useResult
  $Res call(
      {String id,
      String questionId,
      DateTime reviewedAt,
      int quality,
      int interval,
      int repetition,
      double easiness,
      DateTime nextReview});
}

/// @nodoc
class _$ReviewModelCopyWithImpl<$Res, $Val extends ReviewModel>
    implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionId = null,
    Object? reviewedAt = null,
    Object? quality = null,
    Object? interval = null,
    Object? repetition = null,
    Object? easiness = null,
    Object? nextReview = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedAt: null == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      repetition: null == repetition
          ? _value.repetition
          : repetition // ignore: cast_nullable_to_non_nullable
              as int,
      easiness: null == easiness
          ? _value.easiness
          : easiness // ignore: cast_nullable_to_non_nullable
              as double,
      nextReview: null == nextReview
          ? _value.nextReview
          : nextReview // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewModelImplCopyWith<$Res>
    implements $ReviewModelCopyWith<$Res> {
  factory _$$ReviewModelImplCopyWith(
          _$ReviewModelImpl value, $Res Function(_$ReviewModelImpl) then) =
      __$$ReviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String questionId,
      DateTime reviewedAt,
      int quality,
      int interval,
      int repetition,
      double easiness,
      DateTime nextReview});
}

/// @nodoc
class __$$ReviewModelImplCopyWithImpl<$Res>
    extends _$ReviewModelCopyWithImpl<$Res, _$ReviewModelImpl>
    implements _$$ReviewModelImplCopyWith<$Res> {
  __$$ReviewModelImplCopyWithImpl(
      _$ReviewModelImpl _value, $Res Function(_$ReviewModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionId = null,
    Object? reviewedAt = null,
    Object? quality = null,
    Object? interval = null,
    Object? repetition = null,
    Object? easiness = null,
    Object? nextReview = null,
  }) {
    return _then(_$ReviewModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedAt: null == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      repetition: null == repetition
          ? _value.repetition
          : repetition // ignore: cast_nullable_to_non_nullable
              as int,
      easiness: null == easiness
          ? _value.easiness
          : easiness // ignore: cast_nullable_to_non_nullable
              as double,
      nextReview: null == nextReview
          ? _value.nextReview
          : nextReview // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewModelImpl implements _ReviewModel {
  const _$ReviewModelImpl(
      {required this.id,
      required this.questionId,
      required this.reviewedAt,
      required this.quality,
      required this.interval,
      required this.repetition,
      required this.easiness,
      required this.nextReview});

  factory _$ReviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewModelImplFromJson(json);

  @override
  final String id;
  @override
  final String questionId;
  @override
  final DateTime reviewedAt;
  @override
  final int quality;
  @override
  final int interval;
  @override
  final int repetition;
  @override
  final double easiness;
  @override
  final DateTime nextReview;

  @override
  String toString() {
    return 'ReviewModel(id: $id, questionId: $questionId, reviewedAt: $reviewedAt, quality: $quality, interval: $interval, repetition: $repetition, easiness: $easiness, nextReview: $nextReview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.repetition, repetition) ||
                other.repetition == repetition) &&
            (identical(other.easiness, easiness) ||
                other.easiness == easiness) &&
            (identical(other.nextReview, nextReview) ||
                other.nextReview == nextReview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, questionId, reviewedAt,
      quality, interval, repetition, easiness, nextReview);

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      __$$ReviewModelImplCopyWithImpl<_$ReviewModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewModelImplToJson(
      this,
    );
  }
}

abstract class _ReviewModel implements ReviewModel {
  const factory _ReviewModel(
      {required final String id,
      required final String questionId,
      required final DateTime reviewedAt,
      required final int quality,
      required final int interval,
      required final int repetition,
      required final double easiness,
      required final DateTime nextReview}) = _$ReviewModelImpl;

  factory _ReviewModel.fromJson(Map<String, dynamic> json) =
      _$ReviewModelImpl.fromJson;

  @override
  String get id;
  @override
  String get questionId;
  @override
  DateTime get reviewedAt;
  @override
  int get quality;
  @override
  int get interval;
  @override
  int get repetition;
  @override
  double get easiness;
  @override
  DateTime get nextReview;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewSessionStats _$ReviewSessionStatsFromJson(Map<String, dynamic> json) {
  return _ReviewSessionStats.fromJson(json);
}

/// @nodoc
mixin _$ReviewSessionStats {
  int get totalQuestions => throw _privateConstructorUsedError;
  int get correctAnswers => throw _privateConstructorUsedError;
  int get partialCorrect => throw _privateConstructorUsedError;
  int get incorrectAnswers => throw _privateConstructorUsedError;
  double get averageQuality => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this ReviewSessionStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewSessionStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewSessionStatsCopyWith<ReviewSessionStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewSessionStatsCopyWith<$Res> {
  factory $ReviewSessionStatsCopyWith(
          ReviewSessionStats value, $Res Function(ReviewSessionStats) then) =
      _$ReviewSessionStatsCopyWithImpl<$Res, ReviewSessionStats>;
  @useResult
  $Res call(
      {int totalQuestions,
      int correctAnswers,
      int partialCorrect,
      int incorrectAnswers,
      double averageQuality,
      DateTime startedAt,
      DateTime? completedAt});
}

/// @nodoc
class _$ReviewSessionStatsCopyWithImpl<$Res, $Val extends ReviewSessionStats>
    implements $ReviewSessionStatsCopyWith<$Res> {
  _$ReviewSessionStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewSessionStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? partialCorrect = null,
    Object? incorrectAnswers = null,
    Object? averageQuality = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      partialCorrect: null == partialCorrect
          ? _value.partialCorrect
          : partialCorrect // ignore: cast_nullable_to_non_nullable
              as int,
      incorrectAnswers: null == incorrectAnswers
          ? _value.incorrectAnswers
          : incorrectAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      averageQuality: null == averageQuality
          ? _value.averageQuality
          : averageQuality // ignore: cast_nullable_to_non_nullable
              as double,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewSessionStatsImplCopyWith<$Res>
    implements $ReviewSessionStatsCopyWith<$Res> {
  factory _$$ReviewSessionStatsImplCopyWith(_$ReviewSessionStatsImpl value,
          $Res Function(_$ReviewSessionStatsImpl) then) =
      __$$ReviewSessionStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalQuestions,
      int correctAnswers,
      int partialCorrect,
      int incorrectAnswers,
      double averageQuality,
      DateTime startedAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$ReviewSessionStatsImplCopyWithImpl<$Res>
    extends _$ReviewSessionStatsCopyWithImpl<$Res, _$ReviewSessionStatsImpl>
    implements _$$ReviewSessionStatsImplCopyWith<$Res> {
  __$$ReviewSessionStatsImplCopyWithImpl(_$ReviewSessionStatsImpl _value,
      $Res Function(_$ReviewSessionStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReviewSessionStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? partialCorrect = null,
    Object? incorrectAnswers = null,
    Object? averageQuality = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$ReviewSessionStatsImpl(
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      partialCorrect: null == partialCorrect
          ? _value.partialCorrect
          : partialCorrect // ignore: cast_nullable_to_non_nullable
              as int,
      incorrectAnswers: null == incorrectAnswers
          ? _value.incorrectAnswers
          : incorrectAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      averageQuality: null == averageQuality
          ? _value.averageQuality
          : averageQuality // ignore: cast_nullable_to_non_nullable
              as double,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewSessionStatsImpl implements _ReviewSessionStats {
  const _$ReviewSessionStatsImpl(
      {this.totalQuestions = 0,
      this.correctAnswers = 0,
      this.partialCorrect = 0,
      this.incorrectAnswers = 0,
      this.averageQuality = 0.0,
      required this.startedAt,
      this.completedAt});

  factory _$ReviewSessionStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewSessionStatsImplFromJson(json);

  @override
  @JsonKey()
  final int totalQuestions;
  @override
  @JsonKey()
  final int correctAnswers;
  @override
  @JsonKey()
  final int partialCorrect;
  @override
  @JsonKey()
  final int incorrectAnswers;
  @override
  @JsonKey()
  final double averageQuality;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'ReviewSessionStats(totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, partialCorrect: $partialCorrect, incorrectAnswers: $incorrectAnswers, averageQuality: $averageQuality, startedAt: $startedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewSessionStatsImpl &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.partialCorrect, partialCorrect) ||
                other.partialCorrect == partialCorrect) &&
            (identical(other.incorrectAnswers, incorrectAnswers) ||
                other.incorrectAnswers == incorrectAnswers) &&
            (identical(other.averageQuality, averageQuality) ||
                other.averageQuality == averageQuality) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalQuestions, correctAnswers,
      partialCorrect, incorrectAnswers, averageQuality, startedAt, completedAt);

  /// Create a copy of ReviewSessionStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewSessionStatsImplCopyWith<_$ReviewSessionStatsImpl> get copyWith =>
      __$$ReviewSessionStatsImplCopyWithImpl<_$ReviewSessionStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewSessionStatsImplToJson(
      this,
    );
  }
}

abstract class _ReviewSessionStats implements ReviewSessionStats {
  const factory _ReviewSessionStats(
      {final int totalQuestions,
      final int correctAnswers,
      final int partialCorrect,
      final int incorrectAnswers,
      final double averageQuality,
      required final DateTime startedAt,
      final DateTime? completedAt}) = _$ReviewSessionStatsImpl;

  factory _ReviewSessionStats.fromJson(Map<String, dynamic> json) =
      _$ReviewSessionStatsImpl.fromJson;

  @override
  int get totalQuestions;
  @override
  int get correctAnswers;
  @override
  int get partialCorrect;
  @override
  int get incorrectAnswers;
  @override
  double get averageQuality;
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of ReviewSessionStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewSessionStatsImplCopyWith<_$ReviewSessionStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
