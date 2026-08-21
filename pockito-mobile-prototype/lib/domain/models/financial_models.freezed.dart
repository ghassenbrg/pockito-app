// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CurrencyInfo implements DiagnosticableTreeMixin {

 String get code; String get symbol; int get decimals; String get name; String get flag;
/// Create a copy of CurrencyInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrencyInfoCopyWith<CurrencyInfo> get copyWith => _$CurrencyInfoCopyWithImpl<CurrencyInfo>(this as CurrencyInfo, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CurrencyInfo'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('symbol', symbol))..add(DiagnosticsProperty('decimals', decimals))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('flag', flag));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrencyInfo&&(identical(other.code, code) || other.code == code)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.decimals, decimals) || other.decimals == decimals)&&(identical(other.name, name) || other.name == name)&&(identical(other.flag, flag) || other.flag == flag));
}


@override
int get hashCode => Object.hash(runtimeType,code,symbol,decimals,name,flag);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CurrencyInfo(code: $code, symbol: $symbol, decimals: $decimals, name: $name, flag: $flag)';
}


}

/// @nodoc
abstract mixin class $CurrencyInfoCopyWith<$Res>  {
  factory $CurrencyInfoCopyWith(CurrencyInfo value, $Res Function(CurrencyInfo) _then) = _$CurrencyInfoCopyWithImpl;
@useResult
$Res call({
 String code, String symbol, int decimals, String name, String flag
});




}
/// @nodoc
class _$CurrencyInfoCopyWithImpl<$Res>
    implements $CurrencyInfoCopyWith<$Res> {
  _$CurrencyInfoCopyWithImpl(this._self, this._then);

  final CurrencyInfo _self;
  final $Res Function(CurrencyInfo) _then;

/// Create a copy of CurrencyInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? symbol = null,Object? decimals = null,Object? name = null,Object? flag = null,}) {
  return _then(CurrencyInfo(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,flag: null == flag ? _self.flag : flag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrencyInfo].
extension CurrencyInfoPatterns on CurrencyInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrencyInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrencyInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrencyInfo value)  $default,){
final _that = this;
switch (_that) {
case _CurrencyInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrencyInfo value)?  $default,){
final _that = this;
switch (_that) {
case _CurrencyInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String symbol,  int decimals,  String name,  String flag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrencyInfo() when $default != null:
return $default(_that.code,_that.symbol,_that.decimals,_that.name,_that.flag);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String symbol,  int decimals,  String name,  String flag)  $default,) {final _that = this;
switch (_that) {
case _CurrencyInfo():
return $default(_that.code,_that.symbol,_that.decimals,_that.name,_that.flag);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String symbol,  int decimals,  String name,  String flag)?  $default,) {final _that = this;
switch (_that) {
case _CurrencyInfo() when $default != null:
return $default(_that.code,_that.symbol,_that.decimals,_that.name,_that.flag);case _:
  return null;

}
}

}

/// @nodoc


class _CurrencyInfo with DiagnosticableTreeMixin implements CurrencyInfo {
  const _CurrencyInfo({required this.code, required this.symbol, required this.decimals, required this.name, this.flag = ''});
  

@override final  String code;
@override final  String symbol;
@override final  int decimals;
@override final  String name;
@override@JsonKey() final  String flag;

/// Create a copy of CurrencyInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrencyInfoCopyWith<_CurrencyInfo> get copyWith => __$CurrencyInfoCopyWithImpl<_CurrencyInfo>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CurrencyInfo'))
    ..add(DiagnosticsProperty('code', code))..add(DiagnosticsProperty('symbol', symbol))..add(DiagnosticsProperty('decimals', decimals))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('flag', flag));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrencyInfo&&(identical(other.code, code) || other.code == code)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.decimals, decimals) || other.decimals == decimals)&&(identical(other.name, name) || other.name == name)&&(identical(other.flag, flag) || other.flag == flag));
}


@override
int get hashCode => Object.hash(runtimeType,code,symbol,decimals,name,flag);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CurrencyInfo(code: $code, symbol: $symbol, decimals: $decimals, name: $name, flag: $flag)';
}


}

/// @nodoc
abstract mixin class _$CurrencyInfoCopyWith<$Res> implements $CurrencyInfoCopyWith<$Res> {
  factory _$CurrencyInfoCopyWith(_CurrencyInfo value, $Res Function(_CurrencyInfo) _then) = __$CurrencyInfoCopyWithImpl;
@override @useResult
$Res call({
 String code, String symbol, int decimals, String name, String flag
});




}
/// @nodoc
class __$CurrencyInfoCopyWithImpl<$Res>
    implements _$CurrencyInfoCopyWith<$Res> {
  __$CurrencyInfoCopyWithImpl(this._self, this._then);

  final _CurrencyInfo _self;
  final $Res Function(_CurrencyInfo) _then;

/// Create a copy of CurrencyInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? symbol = null,Object? decimals = null,Object? name = null,Object? flag = null,}) {
  return _then(_CurrencyInfo(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,flag: null == flag ? _self.flag : flag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PockitoUser implements DiagnosticableTreeMixin {

 String get id; String get name; String get initials; bool get isYou;
/// Create a copy of PockitoUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PockitoUserCopyWith<PockitoUser> get copyWith => _$PockitoUserCopyWithImpl<PockitoUser>(this as PockitoUser, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PockitoUser'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('initials', initials))..add(DiagnosticsProperty('isYou', isYou));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PockitoUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.initials, initials) || other.initials == initials)&&(identical(other.isYou, isYou) || other.isYou == isYou));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,initials,isYou);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PockitoUser(id: $id, name: $name, initials: $initials, isYou: $isYou)';
}


}

/// @nodoc
abstract mixin class $PockitoUserCopyWith<$Res>  {
  factory $PockitoUserCopyWith(PockitoUser value, $Res Function(PockitoUser) _then) = _$PockitoUserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String initials, bool isYou
});




}
/// @nodoc
class _$PockitoUserCopyWithImpl<$Res>
    implements $PockitoUserCopyWith<$Res> {
  _$PockitoUserCopyWithImpl(this._self, this._then);

  final PockitoUser _self;
  final $Res Function(PockitoUser) _then;

/// Create a copy of PockitoUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? initials = null,Object? isYou = null,}) {
  return _then(PockitoUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,initials: null == initials ? _self.initials : initials // ignore: cast_nullable_to_non_nullable
as String,isYou: null == isYou ? _self.isYou : isYou // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PockitoUser].
extension PockitoUserPatterns on PockitoUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PockitoUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PockitoUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PockitoUser value)  $default,){
final _that = this;
switch (_that) {
case _PockitoUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PockitoUser value)?  $default,){
final _that = this;
switch (_that) {
case _PockitoUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String initials,  bool isYou)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PockitoUser() when $default != null:
return $default(_that.id,_that.name,_that.initials,_that.isYou);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String initials,  bool isYou)  $default,) {final _that = this;
switch (_that) {
case _PockitoUser():
return $default(_that.id,_that.name,_that.initials,_that.isYou);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String initials,  bool isYou)?  $default,) {final _that = this;
switch (_that) {
case _PockitoUser() when $default != null:
return $default(_that.id,_that.name,_that.initials,_that.isYou);case _:
  return null;

}
}

}

/// @nodoc


class _PockitoUser with DiagnosticableTreeMixin implements PockitoUser {
  const _PockitoUser({required this.id, required this.name, required this.initials, this.isYou = false});
  

@override final  String id;
@override final  String name;
@override final  String initials;
@override@JsonKey() final  bool isYou;

/// Create a copy of PockitoUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PockitoUserCopyWith<_PockitoUser> get copyWith => __$PockitoUserCopyWithImpl<_PockitoUser>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PockitoUser'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('initials', initials))..add(DiagnosticsProperty('isYou', isYou));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PockitoUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.initials, initials) || other.initials == initials)&&(identical(other.isYou, isYou) || other.isYou == isYou));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,initials,isYou);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PockitoUser(id: $id, name: $name, initials: $initials, isYou: $isYou)';
}


}

/// @nodoc
abstract mixin class _$PockitoUserCopyWith<$Res> implements $PockitoUserCopyWith<$Res> {
  factory _$PockitoUserCopyWith(_PockitoUser value, $Res Function(_PockitoUser) _then) = __$PockitoUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String initials, bool isYou
});




}
/// @nodoc
class __$PockitoUserCopyWithImpl<$Res>
    implements _$PockitoUserCopyWith<$Res> {
  __$PockitoUserCopyWithImpl(this._self, this._then);

  final _PockitoUser _self;
  final $Res Function(_PockitoUser) _then;

/// Create a copy of PockitoUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? initials = null,Object? isYou = null,}) {
  return _then(_PockitoUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,initials: null == initials ? _self.initials : initials // ignore: cast_nullable_to_non_nullable
as String,isYou: null == isYou ? _self.isYou : isYou // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$UserProfile implements DiagnosticableTreeMixin {

 String get userId; String get displayName; String get email; String get country; String get countryName; String get reportingCurrency; String get locale; String get timezone; ThemeMode get themeMode; String get language; String? get avatarPath; List<String> get recentCurrencies; bool get hapticsOff;/// Masks every balance in the app without changing the layout, so a
/// glance over the shoulder shows the shape of the screen and none of
/// the numbers.
 bool get balancesHidden; List<String> get completedSetupSteps; bool get setupChecklistDismissed; bool get debugToolsEnabled;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UserProfile'))
    ..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('displayName', displayName))..add(DiagnosticsProperty('email', email))..add(DiagnosticsProperty('country', country))..add(DiagnosticsProperty('countryName', countryName))..add(DiagnosticsProperty('reportingCurrency', reportingCurrency))..add(DiagnosticsProperty('locale', locale))..add(DiagnosticsProperty('timezone', timezone))..add(DiagnosticsProperty('themeMode', themeMode))..add(DiagnosticsProperty('language', language))..add(DiagnosticsProperty('avatarPath', avatarPath))..add(DiagnosticsProperty('recentCurrencies', recentCurrencies))..add(DiagnosticsProperty('hapticsOff', hapticsOff))..add(DiagnosticsProperty('balancesHidden', balancesHidden))..add(DiagnosticsProperty('completedSetupSteps', completedSetupSteps))..add(DiagnosticsProperty('setupChecklistDismissed', setupChecklistDismissed))..add(DiagnosticsProperty('debugToolsEnabled', debugToolsEnabled));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.country, country) || other.country == country)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.reportingCurrency, reportingCurrency) || other.reportingCurrency == reportingCurrency)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.language, language) || other.language == language)&&(identical(other.avatarPath, avatarPath) || other.avatarPath == avatarPath)&&const DeepCollectionEquality().equals(other.recentCurrencies, recentCurrencies)&&(identical(other.hapticsOff, hapticsOff) || other.hapticsOff == hapticsOff)&&(identical(other.balancesHidden, balancesHidden) || other.balancesHidden == balancesHidden)&&const DeepCollectionEquality().equals(other.completedSetupSteps, completedSetupSteps)&&(identical(other.setupChecklistDismissed, setupChecklistDismissed) || other.setupChecklistDismissed == setupChecklistDismissed)&&(identical(other.debugToolsEnabled, debugToolsEnabled) || other.debugToolsEnabled == debugToolsEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,userId,displayName,email,country,countryName,reportingCurrency,locale,timezone,themeMode,language,avatarPath,const DeepCollectionEquality().hash(recentCurrencies),hapticsOff,balancesHidden,const DeepCollectionEquality().hash(completedSetupSteps),setupChecklistDismissed,debugToolsEnabled);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UserProfile(userId: $userId, displayName: $displayName, email: $email, country: $country, countryName: $countryName, reportingCurrency: $reportingCurrency, locale: $locale, timezone: $timezone, themeMode: $themeMode, language: $language, avatarPath: $avatarPath, recentCurrencies: $recentCurrencies, hapticsOff: $hapticsOff, balancesHidden: $balancesHidden, completedSetupSteps: $completedSetupSteps, setupChecklistDismissed: $setupChecklistDismissed, debugToolsEnabled: $debugToolsEnabled)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String userId, String displayName, String email, String country, String countryName, String reportingCurrency, String locale, String timezone, ThemeMode themeMode, String language, String? avatarPath, List<String> recentCurrencies, bool hapticsOff, bool balancesHidden, List<String> completedSetupSteps, bool setupChecklistDismissed, bool debugToolsEnabled
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = null,Object? email = null,Object? country = null,Object? countryName = null,Object? reportingCurrency = null,Object? locale = null,Object? timezone = null,Object? themeMode = null,Object? language = null,Object? avatarPath = freezed,Object? recentCurrencies = null,Object? hapticsOff = null,Object? balancesHidden = null,Object? completedSetupSteps = null,Object? setupChecklistDismissed = null,Object? debugToolsEnabled = null,}) {
  return _then(UserProfile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,reportingCurrency: null == reportingCurrency ? _self.reportingCurrency : reportingCurrency // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,avatarPath: freezed == avatarPath ? _self.avatarPath : avatarPath // ignore: cast_nullable_to_non_nullable
as String?,recentCurrencies: null == recentCurrencies ? _self.recentCurrencies : recentCurrencies // ignore: cast_nullable_to_non_nullable
as List<String>,hapticsOff: null == hapticsOff ? _self.hapticsOff : hapticsOff // ignore: cast_nullable_to_non_nullable
as bool,balancesHidden: null == balancesHidden ? _self.balancesHidden : balancesHidden // ignore: cast_nullable_to_non_nullable
as bool,completedSetupSteps: null == completedSetupSteps ? _self.completedSetupSteps : completedSetupSteps // ignore: cast_nullable_to_non_nullable
as List<String>,setupChecklistDismissed: null == setupChecklistDismissed ? _self.setupChecklistDismissed : setupChecklistDismissed // ignore: cast_nullable_to_non_nullable
as bool,debugToolsEnabled: null == debugToolsEnabled ? _self.debugToolsEnabled : debugToolsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String displayName,  String email,  String country,  String countryName,  String reportingCurrency,  String locale,  String timezone,  ThemeMode themeMode,  String language,  String? avatarPath,  List<String> recentCurrencies,  bool hapticsOff,  bool balancesHidden,  List<String> completedSetupSteps,  bool setupChecklistDismissed,  bool debugToolsEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.userId,_that.displayName,_that.email,_that.country,_that.countryName,_that.reportingCurrency,_that.locale,_that.timezone,_that.themeMode,_that.language,_that.avatarPath,_that.recentCurrencies,_that.hapticsOff,_that.balancesHidden,_that.completedSetupSteps,_that.setupChecklistDismissed,_that.debugToolsEnabled);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String displayName,  String email,  String country,  String countryName,  String reportingCurrency,  String locale,  String timezone,  ThemeMode themeMode,  String language,  String? avatarPath,  List<String> recentCurrencies,  bool hapticsOff,  bool balancesHidden,  List<String> completedSetupSteps,  bool setupChecklistDismissed,  bool debugToolsEnabled)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.userId,_that.displayName,_that.email,_that.country,_that.countryName,_that.reportingCurrency,_that.locale,_that.timezone,_that.themeMode,_that.language,_that.avatarPath,_that.recentCurrencies,_that.hapticsOff,_that.balancesHidden,_that.completedSetupSteps,_that.setupChecklistDismissed,_that.debugToolsEnabled);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String displayName,  String email,  String country,  String countryName,  String reportingCurrency,  String locale,  String timezone,  ThemeMode themeMode,  String language,  String? avatarPath,  List<String> recentCurrencies,  bool hapticsOff,  bool balancesHidden,  List<String> completedSetupSteps,  bool setupChecklistDismissed,  bool debugToolsEnabled)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.userId,_that.displayName,_that.email,_that.country,_that.countryName,_that.reportingCurrency,_that.locale,_that.timezone,_that.themeMode,_that.language,_that.avatarPath,_that.recentCurrencies,_that.hapticsOff,_that.balancesHidden,_that.completedSetupSteps,_that.setupChecklistDismissed,_that.debugToolsEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile with DiagnosticableTreeMixin implements UserProfile {
  const _UserProfile({required this.userId, required this.displayName, required this.email, required this.country, required this.countryName, required this.reportingCurrency, required this.locale, required this.timezone, this.themeMode = ThemeMode.system, this.language = 'English', this.avatarPath,  List<String> recentCurrencies = const <String>[], this.hapticsOff = false, this.balancesHidden = false,  List<String> completedSetupSteps = const <String>[], this.setupChecklistDismissed = false, this.debugToolsEnabled = false}): _recentCurrencies = recentCurrencies,_completedSetupSteps = completedSetupSteps;
  

@override final  String userId;
@override final  String displayName;
@override final  String email;
@override final  String country;
@override final  String countryName;
@override final  String reportingCurrency;
@override final  String locale;
@override final  String timezone;
@override@JsonKey() final  ThemeMode themeMode;
@override@JsonKey() final  String language;
@override final  String? avatarPath;
 final  List<String> _recentCurrencies;
@override@JsonKey() List<String> get recentCurrencies {
  if (_recentCurrencies is EqualUnmodifiableListView) return _recentCurrencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentCurrencies);
}

@override@JsonKey() final  bool hapticsOff;
/// Masks every balance in the app without changing the layout, so a
/// glance over the shoulder shows the shape of the screen and none of
/// the numbers.
@override@JsonKey() final  bool balancesHidden;
 final  List<String> _completedSetupSteps;
@override@JsonKey() List<String> get completedSetupSteps {
  if (_completedSetupSteps is EqualUnmodifiableListView) return _completedSetupSteps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedSetupSteps);
}

@override@JsonKey() final  bool setupChecklistDismissed;
@override@JsonKey() final  bool debugToolsEnabled;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UserProfile'))
    ..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('displayName', displayName))..add(DiagnosticsProperty('email', email))..add(DiagnosticsProperty('country', country))..add(DiagnosticsProperty('countryName', countryName))..add(DiagnosticsProperty('reportingCurrency', reportingCurrency))..add(DiagnosticsProperty('locale', locale))..add(DiagnosticsProperty('timezone', timezone))..add(DiagnosticsProperty('themeMode', themeMode))..add(DiagnosticsProperty('language', language))..add(DiagnosticsProperty('avatarPath', avatarPath))..add(DiagnosticsProperty('recentCurrencies', recentCurrencies))..add(DiagnosticsProperty('hapticsOff', hapticsOff))..add(DiagnosticsProperty('balancesHidden', balancesHidden))..add(DiagnosticsProperty('completedSetupSteps', completedSetupSteps))..add(DiagnosticsProperty('setupChecklistDismissed', setupChecklistDismissed))..add(DiagnosticsProperty('debugToolsEnabled', debugToolsEnabled));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.country, country) || other.country == country)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.reportingCurrency, reportingCurrency) || other.reportingCurrency == reportingCurrency)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.language, language) || other.language == language)&&(identical(other.avatarPath, avatarPath) || other.avatarPath == avatarPath)&&const DeepCollectionEquality().equals(other._recentCurrencies, _recentCurrencies)&&(identical(other.hapticsOff, hapticsOff) || other.hapticsOff == hapticsOff)&&(identical(other.balancesHidden, balancesHidden) || other.balancesHidden == balancesHidden)&&const DeepCollectionEquality().equals(other._completedSetupSteps, _completedSetupSteps)&&(identical(other.setupChecklistDismissed, setupChecklistDismissed) || other.setupChecklistDismissed == setupChecklistDismissed)&&(identical(other.debugToolsEnabled, debugToolsEnabled) || other.debugToolsEnabled == debugToolsEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,userId,displayName,email,country,countryName,reportingCurrency,locale,timezone,themeMode,language,avatarPath,const DeepCollectionEquality().hash(_recentCurrencies),hapticsOff,balancesHidden,const DeepCollectionEquality().hash(_completedSetupSteps),setupChecklistDismissed,debugToolsEnabled);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UserProfile(userId: $userId, displayName: $displayName, email: $email, country: $country, countryName: $countryName, reportingCurrency: $reportingCurrency, locale: $locale, timezone: $timezone, themeMode: $themeMode, language: $language, avatarPath: $avatarPath, recentCurrencies: $recentCurrencies, hapticsOff: $hapticsOff, balancesHidden: $balancesHidden, completedSetupSteps: $completedSetupSteps, setupChecklistDismissed: $setupChecklistDismissed, debugToolsEnabled: $debugToolsEnabled)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String userId, String displayName, String email, String country, String countryName, String reportingCurrency, String locale, String timezone, ThemeMode themeMode, String language, String? avatarPath, List<String> recentCurrencies, bool hapticsOff, bool balancesHidden, List<String> completedSetupSteps, bool setupChecklistDismissed, bool debugToolsEnabled
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = null,Object? email = null,Object? country = null,Object? countryName = null,Object? reportingCurrency = null,Object? locale = null,Object? timezone = null,Object? themeMode = null,Object? language = null,Object? avatarPath = freezed,Object? recentCurrencies = null,Object? hapticsOff = null,Object? balancesHidden = null,Object? completedSetupSteps = null,Object? setupChecklistDismissed = null,Object? debugToolsEnabled = null,}) {
  return _then(_UserProfile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,countryName: null == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String,reportingCurrency: null == reportingCurrency ? _self.reportingCurrency : reportingCurrency // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,avatarPath: freezed == avatarPath ? _self.avatarPath : avatarPath // ignore: cast_nullable_to_non_nullable
as String?,recentCurrencies: null == recentCurrencies ? _self._recentCurrencies : recentCurrencies // ignore: cast_nullable_to_non_nullable
as List<String>,hapticsOff: null == hapticsOff ? _self.hapticsOff : hapticsOff // ignore: cast_nullable_to_non_nullable
as bool,balancesHidden: null == balancesHidden ? _self.balancesHidden : balancesHidden // ignore: cast_nullable_to_non_nullable
as bool,completedSetupSteps: null == completedSetupSteps ? _self._completedSetupSteps : completedSetupSteps // ignore: cast_nullable_to_non_nullable
as List<String>,setupChecklistDismissed: null == setupChecklistDismissed ? _self.setupChecklistDismissed : setupChecklistDismissed // ignore: cast_nullable_to_non_nullable
as bool,debugToolsEnabled: null == debugToolsEnabled ? _self.debugToolsEnabled : debugToolsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$Account implements DiagnosticableTreeMixin {

 String get id; String get name; AccountType get type; String get currency; int get openingBalanceMinor; bool get isDefault; bool get archived; int get colorIndex; String get icon; int get sortOrder; String get note;/// Spending headroom on a card. Available balance is the credit limit plus
/// the (negative) current balance.
 int? get creditLimitMinor;/// Savings target. Progress is the current balance against it.
 int? get goalAmountMinor; DateTime? get goalTargetDate; int get version;
/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountCopyWith<Account> get copyWith => _$AccountCopyWithImpl<Account>(this as Account, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Account'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('openingBalanceMinor', openingBalanceMinor))..add(DiagnosticsProperty('isDefault', isDefault))..add(DiagnosticsProperty('archived', archived))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('icon', icon))..add(DiagnosticsProperty('sortOrder', sortOrder))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('creditLimitMinor', creditLimitMinor))..add(DiagnosticsProperty('goalAmountMinor', goalAmountMinor))..add(DiagnosticsProperty('goalTargetDate', goalTargetDate))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Account&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.openingBalanceMinor, openingBalanceMinor) || other.openingBalanceMinor == openingBalanceMinor)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.note, note) || other.note == note)&&(identical(other.creditLimitMinor, creditLimitMinor) || other.creditLimitMinor == creditLimitMinor)&&(identical(other.goalAmountMinor, goalAmountMinor) || other.goalAmountMinor == goalAmountMinor)&&(identical(other.goalTargetDate, goalTargetDate) || other.goalTargetDate == goalTargetDate)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,currency,openingBalanceMinor,isDefault,archived,colorIndex,icon,sortOrder,note,creditLimitMinor,goalAmountMinor,goalTargetDate,version);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Account(id: $id, name: $name, type: $type, currency: $currency, openingBalanceMinor: $openingBalanceMinor, isDefault: $isDefault, archived: $archived, colorIndex: $colorIndex, icon: $icon, sortOrder: $sortOrder, note: $note, creditLimitMinor: $creditLimitMinor, goalAmountMinor: $goalAmountMinor, goalTargetDate: $goalTargetDate, version: $version)';
}


}

/// @nodoc
abstract mixin class $AccountCopyWith<$Res>  {
  factory $AccountCopyWith(Account value, $Res Function(Account) _then) = _$AccountCopyWithImpl;
@useResult
$Res call({
 String id, String name, AccountType type, String currency, int openingBalanceMinor, bool isDefault, bool archived, int colorIndex, String icon, int sortOrder, String note, int? creditLimitMinor, int? goalAmountMinor, DateTime? goalTargetDate, int version
});




}
/// @nodoc
class _$AccountCopyWithImpl<$Res>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._self, this._then);

  final Account _self;
  final $Res Function(Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? currency = null,Object? openingBalanceMinor = null,Object? isDefault = null,Object? archived = null,Object? colorIndex = null,Object? icon = null,Object? sortOrder = null,Object? note = null,Object? creditLimitMinor = freezed,Object? goalAmountMinor = freezed,Object? goalTargetDate = freezed,Object? version = null,}) {
  return _then(Account(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,openingBalanceMinor: null == openingBalanceMinor ? _self.openingBalanceMinor : openingBalanceMinor // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,creditLimitMinor: freezed == creditLimitMinor ? _self.creditLimitMinor : creditLimitMinor // ignore: cast_nullable_to_non_nullable
as int?,goalAmountMinor: freezed == goalAmountMinor ? _self.goalAmountMinor : goalAmountMinor // ignore: cast_nullable_to_non_nullable
as int?,goalTargetDate: freezed == goalTargetDate ? _self.goalTargetDate : goalTargetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Account].
extension AccountPatterns on Account {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Account value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Account value)  $default,){
final _that = this;
switch (_that) {
case _Account():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Account value)?  $default,){
final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AccountType type,  String currency,  int openingBalanceMinor,  bool isDefault,  bool archived,  int colorIndex,  String icon,  int sortOrder,  String note,  int? creditLimitMinor,  int? goalAmountMinor,  DateTime? goalTargetDate,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.currency,_that.openingBalanceMinor,_that.isDefault,_that.archived,_that.colorIndex,_that.icon,_that.sortOrder,_that.note,_that.creditLimitMinor,_that.goalAmountMinor,_that.goalTargetDate,_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AccountType type,  String currency,  int openingBalanceMinor,  bool isDefault,  bool archived,  int colorIndex,  String icon,  int sortOrder,  String note,  int? creditLimitMinor,  int? goalAmountMinor,  DateTime? goalTargetDate,  int version)  $default,) {final _that = this;
switch (_that) {
case _Account():
return $default(_that.id,_that.name,_that.type,_that.currency,_that.openingBalanceMinor,_that.isDefault,_that.archived,_that.colorIndex,_that.icon,_that.sortOrder,_that.note,_that.creditLimitMinor,_that.goalAmountMinor,_that.goalTargetDate,_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AccountType type,  String currency,  int openingBalanceMinor,  bool isDefault,  bool archived,  int colorIndex,  String icon,  int sortOrder,  String note,  int? creditLimitMinor,  int? goalAmountMinor,  DateTime? goalTargetDate,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.currency,_that.openingBalanceMinor,_that.isDefault,_that.archived,_that.colorIndex,_that.icon,_that.sortOrder,_that.note,_that.creditLimitMinor,_that.goalAmountMinor,_that.goalTargetDate,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _Account with DiagnosticableTreeMixin implements Account {
  const _Account({required this.id, required this.name, required this.type, required this.currency, required this.openingBalanceMinor, this.isDefault = false, this.archived = false, this.colorIndex = 0, this.icon = 'wallet', this.sortOrder = 0, this.note = '', this.creditLimitMinor, this.goalAmountMinor, this.goalTargetDate, this.version = 1});
  

@override final  String id;
@override final  String name;
@override final  AccountType type;
@override final  String currency;
@override final  int openingBalanceMinor;
@override@JsonKey() final  bool isDefault;
@override@JsonKey() final  bool archived;
@override@JsonKey() final  int colorIndex;
@override@JsonKey() final  String icon;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  String note;
/// Spending headroom on a card. Available balance is the credit limit plus
/// the (negative) current balance.
@override final  int? creditLimitMinor;
/// Savings target. Progress is the current balance against it.
@override final  int? goalAmountMinor;
@override final  DateTime? goalTargetDate;
@override@JsonKey() final  int version;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountCopyWith<_Account> get copyWith => __$AccountCopyWithImpl<_Account>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Account'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('openingBalanceMinor', openingBalanceMinor))..add(DiagnosticsProperty('isDefault', isDefault))..add(DiagnosticsProperty('archived', archived))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('icon', icon))..add(DiagnosticsProperty('sortOrder', sortOrder))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('creditLimitMinor', creditLimitMinor))..add(DiagnosticsProperty('goalAmountMinor', goalAmountMinor))..add(DiagnosticsProperty('goalTargetDate', goalTargetDate))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Account&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.openingBalanceMinor, openingBalanceMinor) || other.openingBalanceMinor == openingBalanceMinor)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.note, note) || other.note == note)&&(identical(other.creditLimitMinor, creditLimitMinor) || other.creditLimitMinor == creditLimitMinor)&&(identical(other.goalAmountMinor, goalAmountMinor) || other.goalAmountMinor == goalAmountMinor)&&(identical(other.goalTargetDate, goalTargetDate) || other.goalTargetDate == goalTargetDate)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,currency,openingBalanceMinor,isDefault,archived,colorIndex,icon,sortOrder,note,creditLimitMinor,goalAmountMinor,goalTargetDate,version);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Account(id: $id, name: $name, type: $type, currency: $currency, openingBalanceMinor: $openingBalanceMinor, isDefault: $isDefault, archived: $archived, colorIndex: $colorIndex, icon: $icon, sortOrder: $sortOrder, note: $note, creditLimitMinor: $creditLimitMinor, goalAmountMinor: $goalAmountMinor, goalTargetDate: $goalTargetDate, version: $version)';
}


}

/// @nodoc
abstract mixin class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) _then) = __$AccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AccountType type, String currency, int openingBalanceMinor, bool isDefault, bool archived, int colorIndex, String icon, int sortOrder, String note, int? creditLimitMinor, int? goalAmountMinor, DateTime? goalTargetDate, int version
});




}
/// @nodoc
class __$AccountCopyWithImpl<$Res>
    implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(this._self, this._then);

  final _Account _self;
  final $Res Function(_Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? currency = null,Object? openingBalanceMinor = null,Object? isDefault = null,Object? archived = null,Object? colorIndex = null,Object? icon = null,Object? sortOrder = null,Object? note = null,Object? creditLimitMinor = freezed,Object? goalAmountMinor = freezed,Object? goalTargetDate = freezed,Object? version = null,}) {
  return _then(_Account(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AccountType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,openingBalanceMinor: null == openingBalanceMinor ? _self.openingBalanceMinor : openingBalanceMinor // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,creditLimitMinor: freezed == creditLimitMinor ? _self.creditLimitMinor : creditLimitMinor // ignore: cast_nullable_to_non_nullable
as int?,goalAmountMinor: freezed == goalAmountMinor ? _self.goalAmountMinor : goalAmountMinor // ignore: cast_nullable_to_non_nullable
as int?,goalTargetDate: freezed == goalTargetDate ? _self.goalTargetDate : goalTargetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Category implements DiagnosticableTreeMixin {

 String get id; String get name; CategoryType get type; String get icon; int get colorIndex; bool get system;/// Parent in the category tree. One level deep: a child never has children.
 String? get parentId;/// System categories cannot be deleted, so they are hidden instead.
 bool get hidden; int get version;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Category'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('icon', icon))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('system', system))..add(DiagnosticsProperty('parentId', parentId))..add(DiagnosticsProperty('hidden', hidden))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.system, system) || other.system == system)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.hidden, hidden) || other.hidden == hidden)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,icon,colorIndex,system,parentId,hidden,version);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Category(id: $id, name: $name, type: $type, icon: $icon, colorIndex: $colorIndex, system: $system, parentId: $parentId, hidden: $hidden, version: $version)';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, CategoryType type, String icon, int colorIndex, bool system, String? parentId, bool hidden, int version
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? icon = null,Object? colorIndex = null,Object? system = null,Object? parentId = freezed,Object? hidden = null,Object? version = null,}) {
  return _then(Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,system: null == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as bool,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,hidden: null == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Category value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Category value)  $default,){
final _that = this;
switch (_that) {
case _Category():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Category value)?  $default,){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  CategoryType type,  String icon,  int colorIndex,  bool system,  String? parentId,  bool hidden,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.icon,_that.colorIndex,_that.system,_that.parentId,_that.hidden,_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  CategoryType type,  String icon,  int colorIndex,  bool system,  String? parentId,  bool hidden,  int version)  $default,) {final _that = this;
switch (_that) {
case _Category():
return $default(_that.id,_that.name,_that.type,_that.icon,_that.colorIndex,_that.system,_that.parentId,_that.hidden,_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  CategoryType type,  String icon,  int colorIndex,  bool system,  String? parentId,  bool hidden,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.icon,_that.colorIndex,_that.system,_that.parentId,_that.hidden,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _Category with DiagnosticableTreeMixin implements Category {
  const _Category({required this.id, required this.name, required this.type, required this.icon, this.colorIndex = 0, this.system = false, this.parentId, this.hidden = false, this.version = 1});
  

@override final  String id;
@override final  String name;
@override final  CategoryType type;
@override final  String icon;
@override@JsonKey() final  int colorIndex;
@override@JsonKey() final  bool system;
/// Parent in the category tree. One level deep: a child never has children.
@override final  String? parentId;
/// System categories cannot be deleted, so they are hidden instead.
@override@JsonKey() final  bool hidden;
@override@JsonKey() final  int version;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCopyWith<_Category> get copyWith => __$CategoryCopyWithImpl<_Category>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Category'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('icon', icon))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('system', system))..add(DiagnosticsProperty('parentId', parentId))..add(DiagnosticsProperty('hidden', hidden))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Category&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.system, system) || other.system == system)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.hidden, hidden) || other.hidden == hidden)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,icon,colorIndex,system,parentId,hidden,version);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Category(id: $id, name: $name, type: $type, icon: $icon, colorIndex: $colorIndex, system: $system, parentId: $parentId, hidden: $hidden, version: $version)';
}


}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) = __$CategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, CategoryType type, String icon, int colorIndex, bool system, String? parentId, bool hidden, int version
});




}
/// @nodoc
class __$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? icon = null,Object? colorIndex = null,Object? system = null,Object? parentId = freezed,Object? hidden = null,Object? version = null,}) {
  return _then(_Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CategoryType,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,system: null == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as bool,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,hidden: null == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Tag implements DiagnosticableTreeMixin {

 String get id; String get name; int get colorIndex; bool get archived;
/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagCopyWith<Tag> get copyWith => _$TagCopyWithImpl<Tag>(this as Tag, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Tag'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('archived', archived));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tag&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.archived, archived) || other.archived == archived));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,colorIndex,archived);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Tag(id: $id, name: $name, colorIndex: $colorIndex, archived: $archived)';
}


}

/// @nodoc
abstract mixin class $TagCopyWith<$Res>  {
  factory $TagCopyWith(Tag value, $Res Function(Tag) _then) = _$TagCopyWithImpl;
@useResult
$Res call({
 String id, String name, int colorIndex, bool archived
});




}
/// @nodoc
class _$TagCopyWithImpl<$Res>
    implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._self, this._then);

  final Tag _self;
  final $Res Function(Tag) _then;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? colorIndex = null,Object? archived = null,}) {
  return _then(Tag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Tag].
extension TagPatterns on Tag {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tag() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tag value)  $default,){
final _that = this;
switch (_that) {
case _Tag():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tag value)?  $default,){
final _that = this;
switch (_that) {
case _Tag() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int colorIndex,  bool archived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tag() when $default != null:
return $default(_that.id,_that.name,_that.colorIndex,_that.archived);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int colorIndex,  bool archived)  $default,) {final _that = this;
switch (_that) {
case _Tag():
return $default(_that.id,_that.name,_that.colorIndex,_that.archived);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int colorIndex,  bool archived)?  $default,) {final _that = this;
switch (_that) {
case _Tag() when $default != null:
return $default(_that.id,_that.name,_that.colorIndex,_that.archived);case _:
  return null;

}
}

}

/// @nodoc


class _Tag with DiagnosticableTreeMixin implements Tag {
  const _Tag({required this.id, required this.name, this.colorIndex = 0, this.archived = false});
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  int colorIndex;
@override@JsonKey() final  bool archived;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagCopyWith<_Tag> get copyWith => __$TagCopyWithImpl<_Tag>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Tag'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('archived', archived));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tag&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.archived, archived) || other.archived == archived));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,colorIndex,archived);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Tag(id: $id, name: $name, colorIndex: $colorIndex, archived: $archived)';
}


}

/// @nodoc
abstract mixin class _$TagCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$TagCopyWith(_Tag value, $Res Function(_Tag) _then) = __$TagCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int colorIndex, bool archived
});




}
/// @nodoc
class __$TagCopyWithImpl<$Res>
    implements _$TagCopyWith<$Res> {
  __$TagCopyWithImpl(this._self, this._then);

  final _Tag _self;
  final $Res Function(_Tag) _then;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? colorIndex = null,Object? archived = null,}) {
  return _then(_Tag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PaymentMethod implements DiagnosticableTreeMixin {

 String get id; String get name; PaymentMethodKind get kind; String get icon; int get colorIndex; String? get last4;/// The account this method draws on, when it maps to one.
 String? get accountId; bool get archived;
/// Create a copy of PaymentMethod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentMethodCopyWith<PaymentMethod> get copyWith => _$PaymentMethodCopyWithImpl<PaymentMethod>(this as PaymentMethod, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PaymentMethod'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('kind', kind))..add(DiagnosticsProperty('icon', icon))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('last4', last4))..add(DiagnosticsProperty('accountId', accountId))..add(DiagnosticsProperty('archived', archived));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentMethod&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.last4, last4) || other.last4 == last4)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.archived, archived) || other.archived == archived));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,kind,icon,colorIndex,last4,accountId,archived);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PaymentMethod(id: $id, name: $name, kind: $kind, icon: $icon, colorIndex: $colorIndex, last4: $last4, accountId: $accountId, archived: $archived)';
}


}

/// @nodoc
abstract mixin class $PaymentMethodCopyWith<$Res>  {
  factory $PaymentMethodCopyWith(PaymentMethod value, $Res Function(PaymentMethod) _then) = _$PaymentMethodCopyWithImpl;
@useResult
$Res call({
 String id, String name, PaymentMethodKind kind, String icon, int colorIndex, String? last4, String? accountId, bool archived
});




}
/// @nodoc
class _$PaymentMethodCopyWithImpl<$Res>
    implements $PaymentMethodCopyWith<$Res> {
  _$PaymentMethodCopyWithImpl(this._self, this._then);

  final PaymentMethod _self;
  final $Res Function(PaymentMethod) _then;

/// Create a copy of PaymentMethod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? icon = null,Object? colorIndex = null,Object? last4 = freezed,Object? accountId = freezed,Object? archived = null,}) {
  return _then(PaymentMethod(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PaymentMethodKind,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,last4: freezed == last4 ? _self.last4 : last4 // ignore: cast_nullable_to_non_nullable
as String?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentMethod].
extension PaymentMethodPatterns on PaymentMethod {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentMethod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentMethod() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentMethod value)  $default,){
final _that = this;
switch (_that) {
case _PaymentMethod():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentMethod value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentMethod() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  PaymentMethodKind kind,  String icon,  int colorIndex,  String? last4,  String? accountId,  bool archived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentMethod() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.icon,_that.colorIndex,_that.last4,_that.accountId,_that.archived);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  PaymentMethodKind kind,  String icon,  int colorIndex,  String? last4,  String? accountId,  bool archived)  $default,) {final _that = this;
switch (_that) {
case _PaymentMethod():
return $default(_that.id,_that.name,_that.kind,_that.icon,_that.colorIndex,_that.last4,_that.accountId,_that.archived);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  PaymentMethodKind kind,  String icon,  int colorIndex,  String? last4,  String? accountId,  bool archived)?  $default,) {final _that = this;
switch (_that) {
case _PaymentMethod() when $default != null:
return $default(_that.id,_that.name,_that.kind,_that.icon,_that.colorIndex,_that.last4,_that.accountId,_that.archived);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentMethod with DiagnosticableTreeMixin implements PaymentMethod {
  const _PaymentMethod({required this.id, required this.name, required this.kind, this.icon = 'card', this.colorIndex = 0, this.last4, this.accountId, this.archived = false});
  

@override final  String id;
@override final  String name;
@override final  PaymentMethodKind kind;
@override@JsonKey() final  String icon;
@override@JsonKey() final  int colorIndex;
@override final  String? last4;
/// The account this method draws on, when it maps to one.
@override final  String? accountId;
@override@JsonKey() final  bool archived;

/// Create a copy of PaymentMethod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentMethodCopyWith<_PaymentMethod> get copyWith => __$PaymentMethodCopyWithImpl<_PaymentMethod>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PaymentMethod'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('kind', kind))..add(DiagnosticsProperty('icon', icon))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('last4', last4))..add(DiagnosticsProperty('accountId', accountId))..add(DiagnosticsProperty('archived', archived));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentMethod&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.last4, last4) || other.last4 == last4)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.archived, archived) || other.archived == archived));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,kind,icon,colorIndex,last4,accountId,archived);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PaymentMethod(id: $id, name: $name, kind: $kind, icon: $icon, colorIndex: $colorIndex, last4: $last4, accountId: $accountId, archived: $archived)';
}


}

/// @nodoc
abstract mixin class _$PaymentMethodCopyWith<$Res> implements $PaymentMethodCopyWith<$Res> {
  factory _$PaymentMethodCopyWith(_PaymentMethod value, $Res Function(_PaymentMethod) _then) = __$PaymentMethodCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, PaymentMethodKind kind, String icon, int colorIndex, String? last4, String? accountId, bool archived
});




}
/// @nodoc
class __$PaymentMethodCopyWithImpl<$Res>
    implements _$PaymentMethodCopyWith<$Res> {
  __$PaymentMethodCopyWithImpl(this._self, this._then);

  final _PaymentMethod _self;
  final $Res Function(_PaymentMethod) _then;

/// Create a copy of PaymentMethod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? kind = null,Object? icon = null,Object? colorIndex = null,Object? last4 = freezed,Object? accountId = freezed,Object? archived = null,}) {
  return _then(_PaymentMethod(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PaymentMethodKind,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,last4: freezed == last4 ? _self.last4 : last4 // ignore: cast_nullable_to_non_nullable
as String?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ReceiptAttachment implements DiagnosticableTreeMixin {

 String get id; String get label; DateTime get capturedAt; OcrStatus get ocrStatus; int get byteSize;/// Stand-in for the stored image in this local prototype: a stable seed the
/// viewer renders a deterministic placeholder from.
 int get previewSeed; int? get extractedTotalMinor; String? get extractedMerchant; DateTime? get extractedDate; String? get failureReason;
/// Create a copy of ReceiptAttachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptAttachmentCopyWith<ReceiptAttachment> get copyWith => _$ReceiptAttachmentCopyWithImpl<ReceiptAttachment>(this as ReceiptAttachment, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReceiptAttachment'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('label', label))..add(DiagnosticsProperty('capturedAt', capturedAt))..add(DiagnosticsProperty('ocrStatus', ocrStatus))..add(DiagnosticsProperty('byteSize', byteSize))..add(DiagnosticsProperty('previewSeed', previewSeed))..add(DiagnosticsProperty('extractedTotalMinor', extractedTotalMinor))..add(DiagnosticsProperty('extractedMerchant', extractedMerchant))..add(DiagnosticsProperty('extractedDate', extractedDate))..add(DiagnosticsProperty('failureReason', failureReason));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptAttachment&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.ocrStatus, ocrStatus) || other.ocrStatus == ocrStatus)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.previewSeed, previewSeed) || other.previewSeed == previewSeed)&&(identical(other.extractedTotalMinor, extractedTotalMinor) || other.extractedTotalMinor == extractedTotalMinor)&&(identical(other.extractedMerchant, extractedMerchant) || other.extractedMerchant == extractedMerchant)&&(identical(other.extractedDate, extractedDate) || other.extractedDate == extractedDate)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,capturedAt,ocrStatus,byteSize,previewSeed,extractedTotalMinor,extractedMerchant,extractedDate,failureReason);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReceiptAttachment(id: $id, label: $label, capturedAt: $capturedAt, ocrStatus: $ocrStatus, byteSize: $byteSize, previewSeed: $previewSeed, extractedTotalMinor: $extractedTotalMinor, extractedMerchant: $extractedMerchant, extractedDate: $extractedDate, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class $ReceiptAttachmentCopyWith<$Res>  {
  factory $ReceiptAttachmentCopyWith(ReceiptAttachment value, $Res Function(ReceiptAttachment) _then) = _$ReceiptAttachmentCopyWithImpl;
@useResult
$Res call({
 String id, String label, DateTime capturedAt, OcrStatus ocrStatus, int byteSize, int previewSeed, int? extractedTotalMinor, String? extractedMerchant, DateTime? extractedDate, String? failureReason
});




}
/// @nodoc
class _$ReceiptAttachmentCopyWithImpl<$Res>
    implements $ReceiptAttachmentCopyWith<$Res> {
  _$ReceiptAttachmentCopyWithImpl(this._self, this._then);

  final ReceiptAttachment _self;
  final $Res Function(ReceiptAttachment) _then;

/// Create a copy of ReceiptAttachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? capturedAt = null,Object? ocrStatus = null,Object? byteSize = null,Object? previewSeed = null,Object? extractedTotalMinor = freezed,Object? extractedMerchant = freezed,Object? extractedDate = freezed,Object? failureReason = freezed,}) {
  return _then(ReceiptAttachment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ocrStatus: null == ocrStatus ? _self.ocrStatus : ocrStatus // ignore: cast_nullable_to_non_nullable
as OcrStatus,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,previewSeed: null == previewSeed ? _self.previewSeed : previewSeed // ignore: cast_nullable_to_non_nullable
as int,extractedTotalMinor: freezed == extractedTotalMinor ? _self.extractedTotalMinor : extractedTotalMinor // ignore: cast_nullable_to_non_nullable
as int?,extractedMerchant: freezed == extractedMerchant ? _self.extractedMerchant : extractedMerchant // ignore: cast_nullable_to_non_nullable
as String?,extractedDate: freezed == extractedDate ? _self.extractedDate : extractedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptAttachment].
extension ReceiptAttachmentPatterns on ReceiptAttachment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptAttachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptAttachment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptAttachment value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptAttachment():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptAttachment value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptAttachment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  DateTime capturedAt,  OcrStatus ocrStatus,  int byteSize,  int previewSeed,  int? extractedTotalMinor,  String? extractedMerchant,  DateTime? extractedDate,  String? failureReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptAttachment() when $default != null:
return $default(_that.id,_that.label,_that.capturedAt,_that.ocrStatus,_that.byteSize,_that.previewSeed,_that.extractedTotalMinor,_that.extractedMerchant,_that.extractedDate,_that.failureReason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  DateTime capturedAt,  OcrStatus ocrStatus,  int byteSize,  int previewSeed,  int? extractedTotalMinor,  String? extractedMerchant,  DateTime? extractedDate,  String? failureReason)  $default,) {final _that = this;
switch (_that) {
case _ReceiptAttachment():
return $default(_that.id,_that.label,_that.capturedAt,_that.ocrStatus,_that.byteSize,_that.previewSeed,_that.extractedTotalMinor,_that.extractedMerchant,_that.extractedDate,_that.failureReason);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  DateTime capturedAt,  OcrStatus ocrStatus,  int byteSize,  int previewSeed,  int? extractedTotalMinor,  String? extractedMerchant,  DateTime? extractedDate,  String? failureReason)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptAttachment() when $default != null:
return $default(_that.id,_that.label,_that.capturedAt,_that.ocrStatus,_that.byteSize,_that.previewSeed,_that.extractedTotalMinor,_that.extractedMerchant,_that.extractedDate,_that.failureReason);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptAttachment with DiagnosticableTreeMixin implements ReceiptAttachment {
  const _ReceiptAttachment({required this.id, required this.label, required this.capturedAt, this.ocrStatus = OcrStatus.none, this.byteSize = 0, this.previewSeed = 0, this.extractedTotalMinor, this.extractedMerchant, this.extractedDate, this.failureReason});
  

@override final  String id;
@override final  String label;
@override final  DateTime capturedAt;
@override@JsonKey() final  OcrStatus ocrStatus;
@override@JsonKey() final  int byteSize;
/// Stand-in for the stored image in this local prototype: a stable seed the
/// viewer renders a deterministic placeholder from.
@override@JsonKey() final  int previewSeed;
@override final  int? extractedTotalMinor;
@override final  String? extractedMerchant;
@override final  DateTime? extractedDate;
@override final  String? failureReason;

/// Create a copy of ReceiptAttachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptAttachmentCopyWith<_ReceiptAttachment> get copyWith => __$ReceiptAttachmentCopyWithImpl<_ReceiptAttachment>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ReceiptAttachment'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('label', label))..add(DiagnosticsProperty('capturedAt', capturedAt))..add(DiagnosticsProperty('ocrStatus', ocrStatus))..add(DiagnosticsProperty('byteSize', byteSize))..add(DiagnosticsProperty('previewSeed', previewSeed))..add(DiagnosticsProperty('extractedTotalMinor', extractedTotalMinor))..add(DiagnosticsProperty('extractedMerchant', extractedMerchant))..add(DiagnosticsProperty('extractedDate', extractedDate))..add(DiagnosticsProperty('failureReason', failureReason));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptAttachment&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.ocrStatus, ocrStatus) || other.ocrStatus == ocrStatus)&&(identical(other.byteSize, byteSize) || other.byteSize == byteSize)&&(identical(other.previewSeed, previewSeed) || other.previewSeed == previewSeed)&&(identical(other.extractedTotalMinor, extractedTotalMinor) || other.extractedTotalMinor == extractedTotalMinor)&&(identical(other.extractedMerchant, extractedMerchant) || other.extractedMerchant == extractedMerchant)&&(identical(other.extractedDate, extractedDate) || other.extractedDate == extractedDate)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,capturedAt,ocrStatus,byteSize,previewSeed,extractedTotalMinor,extractedMerchant,extractedDate,failureReason);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ReceiptAttachment(id: $id, label: $label, capturedAt: $capturedAt, ocrStatus: $ocrStatus, byteSize: $byteSize, previewSeed: $previewSeed, extractedTotalMinor: $extractedTotalMinor, extractedMerchant: $extractedMerchant, extractedDate: $extractedDate, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class _$ReceiptAttachmentCopyWith<$Res> implements $ReceiptAttachmentCopyWith<$Res> {
  factory _$ReceiptAttachmentCopyWith(_ReceiptAttachment value, $Res Function(_ReceiptAttachment) _then) = __$ReceiptAttachmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, DateTime capturedAt, OcrStatus ocrStatus, int byteSize, int previewSeed, int? extractedTotalMinor, String? extractedMerchant, DateTime? extractedDate, String? failureReason
});




}
/// @nodoc
class __$ReceiptAttachmentCopyWithImpl<$Res>
    implements _$ReceiptAttachmentCopyWith<$Res> {
  __$ReceiptAttachmentCopyWithImpl(this._self, this._then);

  final _ReceiptAttachment _self;
  final $Res Function(_ReceiptAttachment) _then;

/// Create a copy of ReceiptAttachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? capturedAt = null,Object? ocrStatus = null,Object? byteSize = null,Object? previewSeed = null,Object? extractedTotalMinor = freezed,Object? extractedMerchant = freezed,Object? extractedDate = freezed,Object? failureReason = freezed,}) {
  return _then(_ReceiptAttachment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,capturedAt: null == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ocrStatus: null == ocrStatus ? _self.ocrStatus : ocrStatus // ignore: cast_nullable_to_non_nullable
as OcrStatus,byteSize: null == byteSize ? _self.byteSize : byteSize // ignore: cast_nullable_to_non_nullable
as int,previewSeed: null == previewSeed ? _self.previewSeed : previewSeed // ignore: cast_nullable_to_non_nullable
as int,extractedTotalMinor: freezed == extractedTotalMinor ? _self.extractedTotalMinor : extractedTotalMinor // ignore: cast_nullable_to_non_nullable
as int?,extractedMerchant: freezed == extractedMerchant ? _self.extractedMerchant : extractedMerchant // ignore: cast_nullable_to_non_nullable
as String?,extractedDate: freezed == extractedDate ? _self.extractedDate : extractedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SpaceMember implements DiagnosticableTreeMixin {

 String get userId; SpaceRole get role; bool get active; DateTime? get joinedAt;
/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceMemberCopyWith<SpaceMember> get copyWith => _$SpaceMemberCopyWithImpl<SpaceMember>(this as SpaceMember, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpaceMember'))
    ..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('role', role))..add(DiagnosticsProperty('active', active))..add(DiagnosticsProperty('joinedAt', joinedAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.active, active) || other.active == active)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}


@override
int get hashCode => Object.hash(runtimeType,userId,role,active,joinedAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpaceMember(userId: $userId, role: $role, active: $active, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $SpaceMemberCopyWith<$Res>  {
  factory $SpaceMemberCopyWith(SpaceMember value, $Res Function(SpaceMember) _then) = _$SpaceMemberCopyWithImpl;
@useResult
$Res call({
 String userId, SpaceRole role, bool active, DateTime? joinedAt
});




}
/// @nodoc
class _$SpaceMemberCopyWithImpl<$Res>
    implements $SpaceMemberCopyWith<$Res> {
  _$SpaceMemberCopyWithImpl(this._self, this._then);

  final SpaceMember _self;
  final $Res Function(SpaceMember) _then;

/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? role = null,Object? active = null,Object? joinedAt = freezed,}) {
  return _then(SpaceMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as SpaceRole,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceMember].
extension SpaceMemberPatterns on SpaceMember {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceMember value)  $default,){
final _that = this;
switch (_that) {
case _SpaceMember():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceMember value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  SpaceRole role,  bool active,  DateTime? joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
return $default(_that.userId,_that.role,_that.active,_that.joinedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  SpaceRole role,  bool active,  DateTime? joinedAt)  $default,) {final _that = this;
switch (_that) {
case _SpaceMember():
return $default(_that.userId,_that.role,_that.active,_that.joinedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  SpaceRole role,  bool active,  DateTime? joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
return $default(_that.userId,_that.role,_that.active,_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SpaceMember with DiagnosticableTreeMixin implements SpaceMember {
  const _SpaceMember({required this.userId, this.role = SpaceRole.member, this.active = true, this.joinedAt});
  

@override final  String userId;
@override@JsonKey() final  SpaceRole role;
@override@JsonKey() final  bool active;
@override final  DateTime? joinedAt;

/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceMemberCopyWith<_SpaceMember> get copyWith => __$SpaceMemberCopyWithImpl<_SpaceMember>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpaceMember'))
    ..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('role', role))..add(DiagnosticsProperty('active', active))..add(DiagnosticsProperty('joinedAt', joinedAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.active, active) || other.active == active)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}


@override
int get hashCode => Object.hash(runtimeType,userId,role,active,joinedAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpaceMember(userId: $userId, role: $role, active: $active, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$SpaceMemberCopyWith<$Res> implements $SpaceMemberCopyWith<$Res> {
  factory _$SpaceMemberCopyWith(_SpaceMember value, $Res Function(_SpaceMember) _then) = __$SpaceMemberCopyWithImpl;
@override @useResult
$Res call({
 String userId, SpaceRole role, bool active, DateTime? joinedAt
});




}
/// @nodoc
class __$SpaceMemberCopyWithImpl<$Res>
    implements _$SpaceMemberCopyWith<$Res> {
  __$SpaceMemberCopyWithImpl(this._self, this._then);

  final _SpaceMember _self;
  final $Res Function(_SpaceMember) _then;

/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? role = null,Object? active = null,Object? joinedAt = freezed,}) {
  return _then(_SpaceMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as SpaceRole,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$SharedSpace implements DiagnosticableTreeMixin {

 String get id; String get name; SpaceType get type; String get currency; List<SpaceMember> get members; SplitMethod get defaultSplitMethod; Map<String, int> get defaultPercentages; Map<String, int> get defaultAllocations; String get currentCycleId; SpaceStatus get status; int get colorIndex; String get icon; bool get notifyNewExpenses; bool get notifySettlements; bool get notifyAllActivity; int get version;
/// Create a copy of SharedSpace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedSpaceCopyWith<SharedSpace> get copyWith => _$SharedSpaceCopyWithImpl<SharedSpace>(this as SharedSpace, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SharedSpace'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('members', members))..add(DiagnosticsProperty('defaultSplitMethod', defaultSplitMethod))..add(DiagnosticsProperty('defaultPercentages', defaultPercentages))..add(DiagnosticsProperty('defaultAllocations', defaultAllocations))..add(DiagnosticsProperty('currentCycleId', currentCycleId))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('icon', icon))..add(DiagnosticsProperty('notifyNewExpenses', notifyNewExpenses))..add(DiagnosticsProperty('notifySettlements', notifySettlements))..add(DiagnosticsProperty('notifyAllActivity', notifyAllActivity))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedSpace&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.defaultSplitMethod, defaultSplitMethod) || other.defaultSplitMethod == defaultSplitMethod)&&const DeepCollectionEquality().equals(other.defaultPercentages, defaultPercentages)&&const DeepCollectionEquality().equals(other.defaultAllocations, defaultAllocations)&&(identical(other.currentCycleId, currentCycleId) || other.currentCycleId == currentCycleId)&&(identical(other.status, status) || other.status == status)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.notifyNewExpenses, notifyNewExpenses) || other.notifyNewExpenses == notifyNewExpenses)&&(identical(other.notifySettlements, notifySettlements) || other.notifySettlements == notifySettlements)&&(identical(other.notifyAllActivity, notifyAllActivity) || other.notifyAllActivity == notifyAllActivity)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,currency,const DeepCollectionEquality().hash(members),defaultSplitMethod,const DeepCollectionEquality().hash(defaultPercentages),const DeepCollectionEquality().hash(defaultAllocations),currentCycleId,status,colorIndex,icon,notifyNewExpenses,notifySettlements,notifyAllActivity,version);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SharedSpace(id: $id, name: $name, type: $type, currency: $currency, members: $members, defaultSplitMethod: $defaultSplitMethod, defaultPercentages: $defaultPercentages, defaultAllocations: $defaultAllocations, currentCycleId: $currentCycleId, status: $status, colorIndex: $colorIndex, icon: $icon, notifyNewExpenses: $notifyNewExpenses, notifySettlements: $notifySettlements, notifyAllActivity: $notifyAllActivity, version: $version)';
}


}

/// @nodoc
abstract mixin class $SharedSpaceCopyWith<$Res>  {
  factory $SharedSpaceCopyWith(SharedSpace value, $Res Function(SharedSpace) _then) = _$SharedSpaceCopyWithImpl;
@useResult
$Res call({
 String id, String name, SpaceType type, String currency, List<SpaceMember> members, SplitMethod defaultSplitMethod, Map<String, int> defaultPercentages, Map<String, int> defaultAllocations, String currentCycleId, SpaceStatus status, int colorIndex, String icon, bool notifyNewExpenses, bool notifySettlements, bool notifyAllActivity, int version
});




}
/// @nodoc
class _$SharedSpaceCopyWithImpl<$Res>
    implements $SharedSpaceCopyWith<$Res> {
  _$SharedSpaceCopyWithImpl(this._self, this._then);

  final SharedSpace _self;
  final $Res Function(SharedSpace) _then;

/// Create a copy of SharedSpace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? currency = null,Object? members = null,Object? defaultSplitMethod = null,Object? defaultPercentages = null,Object? defaultAllocations = null,Object? currentCycleId = null,Object? status = null,Object? colorIndex = null,Object? icon = null,Object? notifyNewExpenses = null,Object? notifySettlements = null,Object? notifyAllActivity = null,Object? version = null,}) {
  return _then(SharedSpace(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SpaceType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<SpaceMember>,defaultSplitMethod: null == defaultSplitMethod ? _self.defaultSplitMethod : defaultSplitMethod // ignore: cast_nullable_to_non_nullable
as SplitMethod,defaultPercentages: null == defaultPercentages ? _self.defaultPercentages : defaultPercentages // ignore: cast_nullable_to_non_nullable
as Map<String, int>,defaultAllocations: null == defaultAllocations ? _self.defaultAllocations : defaultAllocations // ignore: cast_nullable_to_non_nullable
as Map<String, int>,currentCycleId: null == currentCycleId ? _self.currentCycleId : currentCycleId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SpaceStatus,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,notifyNewExpenses: null == notifyNewExpenses ? _self.notifyNewExpenses : notifyNewExpenses // ignore: cast_nullable_to_non_nullable
as bool,notifySettlements: null == notifySettlements ? _self.notifySettlements : notifySettlements // ignore: cast_nullable_to_non_nullable
as bool,notifyAllActivity: null == notifyAllActivity ? _self.notifyAllActivity : notifyAllActivity // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedSpace].
extension SharedSpacePatterns on SharedSpace {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedSpace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedSpace() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedSpace value)  $default,){
final _that = this;
switch (_that) {
case _SharedSpace():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedSpace value)?  $default,){
final _that = this;
switch (_that) {
case _SharedSpace() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  SpaceType type,  String currency,  List<SpaceMember> members,  SplitMethod defaultSplitMethod,  Map<String, int> defaultPercentages,  Map<String, int> defaultAllocations,  String currentCycleId,  SpaceStatus status,  int colorIndex,  String icon,  bool notifyNewExpenses,  bool notifySettlements,  bool notifyAllActivity,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedSpace() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.currency,_that.members,_that.defaultSplitMethod,_that.defaultPercentages,_that.defaultAllocations,_that.currentCycleId,_that.status,_that.colorIndex,_that.icon,_that.notifyNewExpenses,_that.notifySettlements,_that.notifyAllActivity,_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  SpaceType type,  String currency,  List<SpaceMember> members,  SplitMethod defaultSplitMethod,  Map<String, int> defaultPercentages,  Map<String, int> defaultAllocations,  String currentCycleId,  SpaceStatus status,  int colorIndex,  String icon,  bool notifyNewExpenses,  bool notifySettlements,  bool notifyAllActivity,  int version)  $default,) {final _that = this;
switch (_that) {
case _SharedSpace():
return $default(_that.id,_that.name,_that.type,_that.currency,_that.members,_that.defaultSplitMethod,_that.defaultPercentages,_that.defaultAllocations,_that.currentCycleId,_that.status,_that.colorIndex,_that.icon,_that.notifyNewExpenses,_that.notifySettlements,_that.notifyAllActivity,_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  SpaceType type,  String currency,  List<SpaceMember> members,  SplitMethod defaultSplitMethod,  Map<String, int> defaultPercentages,  Map<String, int> defaultAllocations,  String currentCycleId,  SpaceStatus status,  int colorIndex,  String icon,  bool notifyNewExpenses,  bool notifySettlements,  bool notifyAllActivity,  int version)?  $default,) {final _that = this;
switch (_that) {
case _SharedSpace() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.currency,_that.members,_that.defaultSplitMethod,_that.defaultPercentages,_that.defaultAllocations,_that.currentCycleId,_that.status,_that.colorIndex,_that.icon,_that.notifyNewExpenses,_that.notifySettlements,_that.notifyAllActivity,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _SharedSpace with DiagnosticableTreeMixin implements SharedSpace {
  const _SharedSpace({required this.id, required this.name, required this.type, required this.currency, required  List<SpaceMember> members, required this.defaultSplitMethod,  Map<String, int> defaultPercentages = const <String, int>{},  Map<String, int> defaultAllocations = const <String, int>{}, this.currentCycleId = 'current', this.status = SpaceStatus.active, this.colorIndex = 0, this.icon = 'group', this.notifyNewExpenses = true, this.notifySettlements = true, this.notifyAllActivity = false, this.version = 1}): _members = members,_defaultPercentages = defaultPercentages,_defaultAllocations = defaultAllocations;
  

@override final  String id;
@override final  String name;
@override final  SpaceType type;
@override final  String currency;
 final  List<SpaceMember> _members;
@override List<SpaceMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

@override final  SplitMethod defaultSplitMethod;
 final  Map<String, int> _defaultPercentages;
@override@JsonKey() Map<String, int> get defaultPercentages {
  if (_defaultPercentages is EqualUnmodifiableMapView) return _defaultPercentages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_defaultPercentages);
}

 final  Map<String, int> _defaultAllocations;
@override@JsonKey() Map<String, int> get defaultAllocations {
  if (_defaultAllocations is EqualUnmodifiableMapView) return _defaultAllocations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_defaultAllocations);
}

@override@JsonKey() final  String currentCycleId;
@override@JsonKey() final  SpaceStatus status;
@override@JsonKey() final  int colorIndex;
@override@JsonKey() final  String icon;
@override@JsonKey() final  bool notifyNewExpenses;
@override@JsonKey() final  bool notifySettlements;
@override@JsonKey() final  bool notifyAllActivity;
@override@JsonKey() final  int version;

/// Create a copy of SharedSpace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedSpaceCopyWith<_SharedSpace> get copyWith => __$SharedSpaceCopyWithImpl<_SharedSpace>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SharedSpace'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('members', members))..add(DiagnosticsProperty('defaultSplitMethod', defaultSplitMethod))..add(DiagnosticsProperty('defaultPercentages', defaultPercentages))..add(DiagnosticsProperty('defaultAllocations', defaultAllocations))..add(DiagnosticsProperty('currentCycleId', currentCycleId))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('icon', icon))..add(DiagnosticsProperty('notifyNewExpenses', notifyNewExpenses))..add(DiagnosticsProperty('notifySettlements', notifySettlements))..add(DiagnosticsProperty('notifyAllActivity', notifyAllActivity))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedSpace&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.defaultSplitMethod, defaultSplitMethod) || other.defaultSplitMethod == defaultSplitMethod)&&const DeepCollectionEquality().equals(other._defaultPercentages, _defaultPercentages)&&const DeepCollectionEquality().equals(other._defaultAllocations, _defaultAllocations)&&(identical(other.currentCycleId, currentCycleId) || other.currentCycleId == currentCycleId)&&(identical(other.status, status) || other.status == status)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.notifyNewExpenses, notifyNewExpenses) || other.notifyNewExpenses == notifyNewExpenses)&&(identical(other.notifySettlements, notifySettlements) || other.notifySettlements == notifySettlements)&&(identical(other.notifyAllActivity, notifyAllActivity) || other.notifyAllActivity == notifyAllActivity)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,type,currency,const DeepCollectionEquality().hash(_members),defaultSplitMethod,const DeepCollectionEquality().hash(_defaultPercentages),const DeepCollectionEquality().hash(_defaultAllocations),currentCycleId,status,colorIndex,icon,notifyNewExpenses,notifySettlements,notifyAllActivity,version);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SharedSpace(id: $id, name: $name, type: $type, currency: $currency, members: $members, defaultSplitMethod: $defaultSplitMethod, defaultPercentages: $defaultPercentages, defaultAllocations: $defaultAllocations, currentCycleId: $currentCycleId, status: $status, colorIndex: $colorIndex, icon: $icon, notifyNewExpenses: $notifyNewExpenses, notifySettlements: $notifySettlements, notifyAllActivity: $notifyAllActivity, version: $version)';
}


}

/// @nodoc
abstract mixin class _$SharedSpaceCopyWith<$Res> implements $SharedSpaceCopyWith<$Res> {
  factory _$SharedSpaceCopyWith(_SharedSpace value, $Res Function(_SharedSpace) _then) = __$SharedSpaceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, SpaceType type, String currency, List<SpaceMember> members, SplitMethod defaultSplitMethod, Map<String, int> defaultPercentages, Map<String, int> defaultAllocations, String currentCycleId, SpaceStatus status, int colorIndex, String icon, bool notifyNewExpenses, bool notifySettlements, bool notifyAllActivity, int version
});




}
/// @nodoc
class __$SharedSpaceCopyWithImpl<$Res>
    implements _$SharedSpaceCopyWith<$Res> {
  __$SharedSpaceCopyWithImpl(this._self, this._then);

  final _SharedSpace _self;
  final $Res Function(_SharedSpace) _then;

/// Create a copy of SharedSpace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? currency = null,Object? members = null,Object? defaultSplitMethod = null,Object? defaultPercentages = null,Object? defaultAllocations = null,Object? currentCycleId = null,Object? status = null,Object? colorIndex = null,Object? icon = null,Object? notifyNewExpenses = null,Object? notifySettlements = null,Object? notifyAllActivity = null,Object? version = null,}) {
  return _then(_SharedSpace(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SpaceType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<SpaceMember>,defaultSplitMethod: null == defaultSplitMethod ? _self.defaultSplitMethod : defaultSplitMethod // ignore: cast_nullable_to_non_nullable
as SplitMethod,defaultPercentages: null == defaultPercentages ? _self._defaultPercentages : defaultPercentages // ignore: cast_nullable_to_non_nullable
as Map<String, int>,defaultAllocations: null == defaultAllocations ? _self._defaultAllocations : defaultAllocations // ignore: cast_nullable_to_non_nullable
as Map<String, int>,currentCycleId: null == currentCycleId ? _self.currentCycleId : currentCycleId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SpaceStatus,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,notifyNewExpenses: null == notifyNewExpenses ? _self.notifyNewExpenses : notifyNewExpenses // ignore: cast_nullable_to_non_nullable
as bool,notifySettlements: null == notifySettlements ? _self.notifySettlements : notifySettlements // ignore: cast_nullable_to_non_nullable
as bool,notifyAllActivity: null == notifyAllActivity ? _self.notifyAllActivity : notifyAllActivity // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SplitShare implements DiagnosticableTreeMixin {

 String get userId; int get amountMinor;
/// Create a copy of SplitShare
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SplitShareCopyWith<SplitShare> get copyWith => _$SplitShareCopyWithImpl<SplitShare>(this as SplitShare, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SplitShare'))
    ..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('amountMinor', amountMinor));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SplitShare&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,userId,amountMinor);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SplitShare(userId: $userId, amountMinor: $amountMinor)';
}


}

/// @nodoc
abstract mixin class $SplitShareCopyWith<$Res>  {
  factory $SplitShareCopyWith(SplitShare value, $Res Function(SplitShare) _then) = _$SplitShareCopyWithImpl;
@useResult
$Res call({
 String userId, int amountMinor
});




}
/// @nodoc
class _$SplitShareCopyWithImpl<$Res>
    implements $SplitShareCopyWith<$Res> {
  _$SplitShareCopyWithImpl(this._self, this._then);

  final SplitShare _self;
  final $Res Function(SplitShare) _then;

/// Create a copy of SplitShare
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? amountMinor = null,}) {
  return _then(SplitShare(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SplitShare].
extension SplitSharePatterns on SplitShare {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SplitShare value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SplitShare() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SplitShare value)  $default,){
final _that = this;
switch (_that) {
case _SplitShare():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SplitShare value)?  $default,){
final _that = this;
switch (_that) {
case _SplitShare() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  int amountMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SplitShare() when $default != null:
return $default(_that.userId,_that.amountMinor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  int amountMinor)  $default,) {final _that = this;
switch (_that) {
case _SplitShare():
return $default(_that.userId,_that.amountMinor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  int amountMinor)?  $default,) {final _that = this;
switch (_that) {
case _SplitShare() when $default != null:
return $default(_that.userId,_that.amountMinor);case _:
  return null;

}
}

}

/// @nodoc


class _SplitShare with DiagnosticableTreeMixin implements SplitShare {
  const _SplitShare({required this.userId, required this.amountMinor});
  

@override final  String userId;
@override final  int amountMinor;

/// Create a copy of SplitShare
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SplitShareCopyWith<_SplitShare> get copyWith => __$SplitShareCopyWithImpl<_SplitShare>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SplitShare'))
    ..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('amountMinor', amountMinor));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplitShare&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor));
}


@override
int get hashCode => Object.hash(runtimeType,userId,amountMinor);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SplitShare(userId: $userId, amountMinor: $amountMinor)';
}


}

/// @nodoc
abstract mixin class _$SplitShareCopyWith<$Res> implements $SplitShareCopyWith<$Res> {
  factory _$SplitShareCopyWith(_SplitShare value, $Res Function(_SplitShare) _then) = __$SplitShareCopyWithImpl;
@override @useResult
$Res call({
 String userId, int amountMinor
});




}
/// @nodoc
class __$SplitShareCopyWithImpl<$Res>
    implements _$SplitShareCopyWith<$Res> {
  __$SplitShareCopyWithImpl(this._self, this._then);

  final _SplitShare _self;
  final $Res Function(_SplitShare) _then;

/// Create a copy of SplitShare
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? amountMinor = null,}) {
  return _then(_SplitShare(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SplitItem implements DiagnosticableTreeMixin {

 String get id; String get label; int get amountMinor; List<String> get participantIds;
/// Create a copy of SplitItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SplitItemCopyWith<SplitItem> get copyWith => _$SplitItemCopyWithImpl<SplitItem>(this as SplitItem, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SplitItem'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('label', label))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('participantIds', participantIds));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SplitItem&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&const DeepCollectionEquality().equals(other.participantIds, participantIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,amountMinor,const DeepCollectionEquality().hash(participantIds));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SplitItem(id: $id, label: $label, amountMinor: $amountMinor, participantIds: $participantIds)';
}


}

/// @nodoc
abstract mixin class $SplitItemCopyWith<$Res>  {
  factory $SplitItemCopyWith(SplitItem value, $Res Function(SplitItem) _then) = _$SplitItemCopyWithImpl;
@useResult
$Res call({
 String id, String label, int amountMinor, List<String> participantIds
});




}
/// @nodoc
class _$SplitItemCopyWithImpl<$Res>
    implements $SplitItemCopyWith<$Res> {
  _$SplitItemCopyWithImpl(this._self, this._then);

  final SplitItem _self;
  final $Res Function(SplitItem) _then;

/// Create a copy of SplitItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? amountMinor = null,Object? participantIds = null,}) {
  return _then(SplitItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,participantIds: null == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SplitItem].
extension SplitItemPatterns on SplitItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SplitItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SplitItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SplitItem value)  $default,){
final _that = this;
switch (_that) {
case _SplitItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SplitItem value)?  $default,){
final _that = this;
switch (_that) {
case _SplitItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  int amountMinor,  List<String> participantIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SplitItem() when $default != null:
return $default(_that.id,_that.label,_that.amountMinor,_that.participantIds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  int amountMinor,  List<String> participantIds)  $default,) {final _that = this;
switch (_that) {
case _SplitItem():
return $default(_that.id,_that.label,_that.amountMinor,_that.participantIds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  int amountMinor,  List<String> participantIds)?  $default,) {final _that = this;
switch (_that) {
case _SplitItem() when $default != null:
return $default(_that.id,_that.label,_that.amountMinor,_that.participantIds);case _:
  return null;

}
}

}

/// @nodoc


class _SplitItem with DiagnosticableTreeMixin implements SplitItem {
  const _SplitItem({required this.id, required this.label, required this.amountMinor, required  List<String> participantIds}): _participantIds = participantIds;
  

@override final  String id;
@override final  String label;
@override final  int amountMinor;
 final  List<String> _participantIds;
@override List<String> get participantIds {
  if (_participantIds is EqualUnmodifiableListView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantIds);
}


/// Create a copy of SplitItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SplitItemCopyWith<_SplitItem> get copyWith => __$SplitItemCopyWithImpl<_SplitItem>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SplitItem'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('label', label))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('participantIds', participantIds));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplitItem&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&const DeepCollectionEquality().equals(other._participantIds, _participantIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,amountMinor,const DeepCollectionEquality().hash(_participantIds));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SplitItem(id: $id, label: $label, amountMinor: $amountMinor, participantIds: $participantIds)';
}


}

/// @nodoc
abstract mixin class _$SplitItemCopyWith<$Res> implements $SplitItemCopyWith<$Res> {
  factory _$SplitItemCopyWith(_SplitItem value, $Res Function(_SplitItem) _then) = __$SplitItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, int amountMinor, List<String> participantIds
});




}
/// @nodoc
class __$SplitItemCopyWithImpl<$Res>
    implements _$SplitItemCopyWith<$Res> {
  __$SplitItemCopyWithImpl(this._self, this._then);

  final _SplitItem _self;
  final $Res Function(_SplitItem) _then;

/// Create a copy of SplitItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? amountMinor = null,Object? participantIds = null,}) {
  return _then(_SplitItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,participantIds: null == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$ExpensePayer implements DiagnosticableTreeMixin {

 String get userId; int get amountMinor;/// The payer's own account, recorded only when the payer is you — nobody
/// else's ledger lives in this app.
 String? get accountId;
/// Create a copy of ExpensePayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpensePayerCopyWith<ExpensePayer> get copyWith => _$ExpensePayerCopyWithImpl<ExpensePayer>(this as ExpensePayer, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExpensePayer'))
    ..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('accountId', accountId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpensePayer&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}


@override
int get hashCode => Object.hash(runtimeType,userId,amountMinor,accountId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExpensePayer(userId: $userId, amountMinor: $amountMinor, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class $ExpensePayerCopyWith<$Res>  {
  factory $ExpensePayerCopyWith(ExpensePayer value, $Res Function(ExpensePayer) _then) = _$ExpensePayerCopyWithImpl;
@useResult
$Res call({
 String userId, int amountMinor, String? accountId
});




}
/// @nodoc
class _$ExpensePayerCopyWithImpl<$Res>
    implements $ExpensePayerCopyWith<$Res> {
  _$ExpensePayerCopyWithImpl(this._self, this._then);

  final ExpensePayer _self;
  final $Res Function(ExpensePayer) _then;

/// Create a copy of ExpensePayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? amountMinor = null,Object? accountId = freezed,}) {
  return _then(ExpensePayer(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpensePayer].
extension ExpensePayerPatterns on ExpensePayer {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpensePayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpensePayer() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpensePayer value)  $default,){
final _that = this;
switch (_that) {
case _ExpensePayer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpensePayer value)?  $default,){
final _that = this;
switch (_that) {
case _ExpensePayer() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  int amountMinor,  String? accountId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpensePayer() when $default != null:
return $default(_that.userId,_that.amountMinor,_that.accountId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  int amountMinor,  String? accountId)  $default,) {final _that = this;
switch (_that) {
case _ExpensePayer():
return $default(_that.userId,_that.amountMinor,_that.accountId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  int amountMinor,  String? accountId)?  $default,) {final _that = this;
switch (_that) {
case _ExpensePayer() when $default != null:
return $default(_that.userId,_that.amountMinor,_that.accountId);case _:
  return null;

}
}

}

/// @nodoc


class _ExpensePayer with DiagnosticableTreeMixin implements ExpensePayer {
  const _ExpensePayer({required this.userId, required this.amountMinor, this.accountId});
  

@override final  String userId;
@override final  int amountMinor;
/// The payer's own account, recorded only when the payer is you — nobody
/// else's ledger lives in this app.
@override final  String? accountId;

/// Create a copy of ExpensePayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpensePayerCopyWith<_ExpensePayer> get copyWith => __$ExpensePayerCopyWithImpl<_ExpensePayer>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExpensePayer'))
    ..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('accountId', accountId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpensePayer&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}


@override
int get hashCode => Object.hash(runtimeType,userId,amountMinor,accountId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExpensePayer(userId: $userId, amountMinor: $amountMinor, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class _$ExpensePayerCopyWith<$Res> implements $ExpensePayerCopyWith<$Res> {
  factory _$ExpensePayerCopyWith(_ExpensePayer value, $Res Function(_ExpensePayer) _then) = __$ExpensePayerCopyWithImpl;
@override @useResult
$Res call({
 String userId, int amountMinor, String? accountId
});




}
/// @nodoc
class __$ExpensePayerCopyWithImpl<$Res>
    implements _$ExpensePayerCopyWith<$Res> {
  __$ExpensePayerCopyWithImpl(this._self, this._then);

  final _ExpensePayer _self;
  final $Res Function(_ExpensePayer) _then;

/// Create a copy of ExpensePayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? amountMinor = null,Object? accountId = freezed,}) {
  return _then(_ExpensePayer(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SharedExpense implements DiagnosticableTreeMixin {

 String get id; String get spaceId; String get title; int get totalMinor; String get currency; DateTime get occurredOn; String get categoryId; SplitMethod get method;/// Everyone who paid. The sum of `amountMinor` always equals `totalMinor`.
 List<ExpensePayer> get payers; List<SplitShare> get shares; List<SplitItem> get items; String get cycleId; String? get paidFromAccountId; int? get walletAmountMinor; String? get walletCurrency; double? get exchangeRate; FxRateMode? get fxRateMode; DateTime? get rateUpdatedAt; String get source; String? get client; RecordStatus get status; String get note; List<String> get tagIds; List<ReceiptAttachment> get attachments;/// Who recorded it. Editing someone else's expense needs admin rights.
 String get createdByUserId; DateTime? get voidedAt; String? get voidReason; int get version;
/// Create a copy of SharedExpense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedExpenseCopyWith<SharedExpense> get copyWith => _$SharedExpenseCopyWithImpl<SharedExpense>(this as SharedExpense, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SharedExpense'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('totalMinor', totalMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('occurredOn', occurredOn))..add(DiagnosticsProperty('categoryId', categoryId))..add(DiagnosticsProperty('method', method))..add(DiagnosticsProperty('payers', payers))..add(DiagnosticsProperty('shares', shares))..add(DiagnosticsProperty('items', items))..add(DiagnosticsProperty('cycleId', cycleId))..add(DiagnosticsProperty('paidFromAccountId', paidFromAccountId))..add(DiagnosticsProperty('walletAmountMinor', walletAmountMinor))..add(DiagnosticsProperty('walletCurrency', walletCurrency))..add(DiagnosticsProperty('exchangeRate', exchangeRate))..add(DiagnosticsProperty('fxRateMode', fxRateMode))..add(DiagnosticsProperty('rateUpdatedAt', rateUpdatedAt))..add(DiagnosticsProperty('source', source))..add(DiagnosticsProperty('client', client))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('tagIds', tagIds))..add(DiagnosticsProperty('attachments', attachments))..add(DiagnosticsProperty('createdByUserId', createdByUserId))..add(DiagnosticsProperty('voidedAt', voidedAt))..add(DiagnosticsProperty('voidReason', voidReason))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other.payers, payers)&&const DeepCollectionEquality().equals(other.shares, shares)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.paidFromAccountId, paidFromAccountId) || other.paidFromAccountId == paidFromAccountId)&&(identical(other.walletAmountMinor, walletAmountMinor) || other.walletAmountMinor == walletAmountMinor)&&(identical(other.walletCurrency, walletCurrency) || other.walletCurrency == walletCurrency)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.fxRateMode, fxRateMode) || other.fxRateMode == fxRateMode)&&(identical(other.rateUpdatedAt, rateUpdatedAt) || other.rateUpdatedAt == rateUpdatedAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.client, client) || other.client == client)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other.tagIds, tagIds)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.voidedAt, voidedAt) || other.voidedAt == voidedAt)&&(identical(other.voidReason, voidReason) || other.voidReason == voidReason)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,spaceId,title,totalMinor,currency,occurredOn,categoryId,method,const DeepCollectionEquality().hash(payers),const DeepCollectionEquality().hash(shares),const DeepCollectionEquality().hash(items),cycleId,paidFromAccountId,walletAmountMinor,walletCurrency,exchangeRate,fxRateMode,rateUpdatedAt,source,client,status,note,const DeepCollectionEquality().hash(tagIds),const DeepCollectionEquality().hash(attachments),createdByUserId,voidedAt,voidReason,version]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SharedExpense(id: $id, spaceId: $spaceId, title: $title, totalMinor: $totalMinor, currency: $currency, occurredOn: $occurredOn, categoryId: $categoryId, method: $method, payers: $payers, shares: $shares, items: $items, cycleId: $cycleId, paidFromAccountId: $paidFromAccountId, walletAmountMinor: $walletAmountMinor, walletCurrency: $walletCurrency, exchangeRate: $exchangeRate, fxRateMode: $fxRateMode, rateUpdatedAt: $rateUpdatedAt, source: $source, client: $client, status: $status, note: $note, tagIds: $tagIds, attachments: $attachments, createdByUserId: $createdByUserId, voidedAt: $voidedAt, voidReason: $voidReason, version: $version)';
}


}

/// @nodoc
abstract mixin class $SharedExpenseCopyWith<$Res>  {
  factory $SharedExpenseCopyWith(SharedExpense value, $Res Function(SharedExpense) _then) = _$SharedExpenseCopyWithImpl;
@useResult
$Res call({
 String id, String spaceId, String title, int totalMinor, String currency, DateTime occurredOn, String categoryId, SplitMethod method, List<ExpensePayer> payers, List<SplitShare> shares, List<SplitItem> items, String cycleId, String? paidFromAccountId, int? walletAmountMinor, String? walletCurrency, double? exchangeRate, FxRateMode? fxRateMode, DateTime? rateUpdatedAt, String source, String? client, RecordStatus status, String note, List<String> tagIds, List<ReceiptAttachment> attachments, String createdByUserId, DateTime? voidedAt, String? voidReason, int version
});




}
/// @nodoc
class _$SharedExpenseCopyWithImpl<$Res>
    implements $SharedExpenseCopyWith<$Res> {
  _$SharedExpenseCopyWithImpl(this._self, this._then);

  final SharedExpense _self;
  final $Res Function(SharedExpense) _then;

/// Create a copy of SharedExpense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = null,Object? title = null,Object? totalMinor = null,Object? currency = null,Object? occurredOn = null,Object? categoryId = null,Object? method = null,Object? payers = null,Object? shares = null,Object? items = null,Object? cycleId = null,Object? paidFromAccountId = freezed,Object? walletAmountMinor = freezed,Object? walletCurrency = freezed,Object? exchangeRate = freezed,Object? fxRateMode = freezed,Object? rateUpdatedAt = freezed,Object? source = null,Object? client = freezed,Object? status = null,Object? note = null,Object? tagIds = null,Object? attachments = null,Object? createdByUserId = null,Object? voidedAt = freezed,Object? voidReason = freezed,Object? version = null,}) {
  return _then(SharedExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as SplitMethod,payers: null == payers ? _self.payers : payers // ignore: cast_nullable_to_non_nullable
as List<ExpensePayer>,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as List<SplitShare>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SplitItem>,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String,paidFromAccountId: freezed == paidFromAccountId ? _self.paidFromAccountId : paidFromAccountId // ignore: cast_nullable_to_non_nullable
as String?,walletAmountMinor: freezed == walletAmountMinor ? _self.walletAmountMinor : walletAmountMinor // ignore: cast_nullable_to_non_nullable
as int?,walletCurrency: freezed == walletCurrency ? _self.walletCurrency : walletCurrency // ignore: cast_nullable_to_non_nullable
as String?,exchangeRate: freezed == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double?,fxRateMode: freezed == fxRateMode ? _self.fxRateMode : fxRateMode // ignore: cast_nullable_to_non_nullable
as FxRateMode?,rateUpdatedAt: freezed == rateUpdatedAt ? _self.rateUpdatedAt : rateUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecordStatus,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,tagIds: null == tagIds ? _self.tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ReceiptAttachment>,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,voidedAt: freezed == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,voidReason: freezed == voidReason ? _self.voidReason : voidReason // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedExpense].
extension SharedExpensePatterns on SharedExpense {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedExpense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedExpense() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedExpense value)  $default,){
final _that = this;
switch (_that) {
case _SharedExpense():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedExpense value)?  $default,){
final _that = this;
switch (_that) {
case _SharedExpense() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String spaceId,  String title,  int totalMinor,  String currency,  DateTime occurredOn,  String categoryId,  SplitMethod method,  List<ExpensePayer> payers,  List<SplitShare> shares,  List<SplitItem> items,  String cycleId,  String? paidFromAccountId,  int? walletAmountMinor,  String? walletCurrency,  double? exchangeRate,  FxRateMode? fxRateMode,  DateTime? rateUpdatedAt,  String source,  String? client,  RecordStatus status,  String note,  List<String> tagIds,  List<ReceiptAttachment> attachments,  String createdByUserId,  DateTime? voidedAt,  String? voidReason,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedExpense() when $default != null:
return $default(_that.id,_that.spaceId,_that.title,_that.totalMinor,_that.currency,_that.occurredOn,_that.categoryId,_that.method,_that.payers,_that.shares,_that.items,_that.cycleId,_that.paidFromAccountId,_that.walletAmountMinor,_that.walletCurrency,_that.exchangeRate,_that.fxRateMode,_that.rateUpdatedAt,_that.source,_that.client,_that.status,_that.note,_that.tagIds,_that.attachments,_that.createdByUserId,_that.voidedAt,_that.voidReason,_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String spaceId,  String title,  int totalMinor,  String currency,  DateTime occurredOn,  String categoryId,  SplitMethod method,  List<ExpensePayer> payers,  List<SplitShare> shares,  List<SplitItem> items,  String cycleId,  String? paidFromAccountId,  int? walletAmountMinor,  String? walletCurrency,  double? exchangeRate,  FxRateMode? fxRateMode,  DateTime? rateUpdatedAt,  String source,  String? client,  RecordStatus status,  String note,  List<String> tagIds,  List<ReceiptAttachment> attachments,  String createdByUserId,  DateTime? voidedAt,  String? voidReason,  int version)  $default,) {final _that = this;
switch (_that) {
case _SharedExpense():
return $default(_that.id,_that.spaceId,_that.title,_that.totalMinor,_that.currency,_that.occurredOn,_that.categoryId,_that.method,_that.payers,_that.shares,_that.items,_that.cycleId,_that.paidFromAccountId,_that.walletAmountMinor,_that.walletCurrency,_that.exchangeRate,_that.fxRateMode,_that.rateUpdatedAt,_that.source,_that.client,_that.status,_that.note,_that.tagIds,_that.attachments,_that.createdByUserId,_that.voidedAt,_that.voidReason,_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String spaceId,  String title,  int totalMinor,  String currency,  DateTime occurredOn,  String categoryId,  SplitMethod method,  List<ExpensePayer> payers,  List<SplitShare> shares,  List<SplitItem> items,  String cycleId,  String? paidFromAccountId,  int? walletAmountMinor,  String? walletCurrency,  double? exchangeRate,  FxRateMode? fxRateMode,  DateTime? rateUpdatedAt,  String source,  String? client,  RecordStatus status,  String note,  List<String> tagIds,  List<ReceiptAttachment> attachments,  String createdByUserId,  DateTime? voidedAt,  String? voidReason,  int version)?  $default,) {final _that = this;
switch (_that) {
case _SharedExpense() when $default != null:
return $default(_that.id,_that.spaceId,_that.title,_that.totalMinor,_that.currency,_that.occurredOn,_that.categoryId,_that.method,_that.payers,_that.shares,_that.items,_that.cycleId,_that.paidFromAccountId,_that.walletAmountMinor,_that.walletCurrency,_that.exchangeRate,_that.fxRateMode,_that.rateUpdatedAt,_that.source,_that.client,_that.status,_that.note,_that.tagIds,_that.attachments,_that.createdByUserId,_that.voidedAt,_that.voidReason,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _SharedExpense with DiagnosticableTreeMixin implements SharedExpense {
  const _SharedExpense({required this.id, required this.spaceId, required this.title, required this.totalMinor, required this.currency, required this.occurredOn, required this.categoryId, required this.method, required  List<ExpensePayer> payers, required  List<SplitShare> shares,  List<SplitItem> items = const <SplitItem>[], this.cycleId = 'current', this.paidFromAccountId, this.walletAmountMinor, this.walletCurrency, this.exchangeRate, this.fxRateMode, this.rateUpdatedAt, this.source = 'mobile', this.client, this.status = RecordStatus.confirmed, this.note = '',  List<String> tagIds = const <String>[],  List<ReceiptAttachment> attachments = const <ReceiptAttachment>[], this.createdByUserId = '', this.voidedAt, this.voidReason, this.version = 1}): _payers = payers,_shares = shares,_items = items,_tagIds = tagIds,_attachments = attachments;
  

@override final  String id;
@override final  String spaceId;
@override final  String title;
@override final  int totalMinor;
@override final  String currency;
@override final  DateTime occurredOn;
@override final  String categoryId;
@override final  SplitMethod method;
/// Everyone who paid. The sum of `amountMinor` always equals `totalMinor`.
 final  List<ExpensePayer> _payers;
/// Everyone who paid. The sum of `amountMinor` always equals `totalMinor`.
@override List<ExpensePayer> get payers {
  if (_payers is EqualUnmodifiableListView) return _payers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payers);
}

 final  List<SplitShare> _shares;
@override List<SplitShare> get shares {
  if (_shares is EqualUnmodifiableListView) return _shares;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shares);
}

 final  List<SplitItem> _items;
@override@JsonKey() List<SplitItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  String cycleId;
@override final  String? paidFromAccountId;
@override final  int? walletAmountMinor;
@override final  String? walletCurrency;
@override final  double? exchangeRate;
@override final  FxRateMode? fxRateMode;
@override final  DateTime? rateUpdatedAt;
@override@JsonKey() final  String source;
@override final  String? client;
@override@JsonKey() final  RecordStatus status;
@override@JsonKey() final  String note;
 final  List<String> _tagIds;
@override@JsonKey() List<String> get tagIds {
  if (_tagIds is EqualUnmodifiableListView) return _tagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagIds);
}

 final  List<ReceiptAttachment> _attachments;
@override@JsonKey() List<ReceiptAttachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

/// Who recorded it. Editing someone else's expense needs admin rights.
@override@JsonKey() final  String createdByUserId;
@override final  DateTime? voidedAt;
@override final  String? voidReason;
@override@JsonKey() final  int version;

/// Create a copy of SharedExpense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedExpenseCopyWith<_SharedExpense> get copyWith => __$SharedExpenseCopyWithImpl<_SharedExpense>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SharedExpense'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('totalMinor', totalMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('occurredOn', occurredOn))..add(DiagnosticsProperty('categoryId', categoryId))..add(DiagnosticsProperty('method', method))..add(DiagnosticsProperty('payers', payers))..add(DiagnosticsProperty('shares', shares))..add(DiagnosticsProperty('items', items))..add(DiagnosticsProperty('cycleId', cycleId))..add(DiagnosticsProperty('paidFromAccountId', paidFromAccountId))..add(DiagnosticsProperty('walletAmountMinor', walletAmountMinor))..add(DiagnosticsProperty('walletCurrency', walletCurrency))..add(DiagnosticsProperty('exchangeRate', exchangeRate))..add(DiagnosticsProperty('fxRateMode', fxRateMode))..add(DiagnosticsProperty('rateUpdatedAt', rateUpdatedAt))..add(DiagnosticsProperty('source', source))..add(DiagnosticsProperty('client', client))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('tagIds', tagIds))..add(DiagnosticsProperty('attachments', attachments))..add(DiagnosticsProperty('createdByUserId', createdByUserId))..add(DiagnosticsProperty('voidedAt', voidedAt))..add(DiagnosticsProperty('voidReason', voidReason))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.title, title) || other.title == title)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other._payers, _payers)&&const DeepCollectionEquality().equals(other._shares, _shares)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.paidFromAccountId, paidFromAccountId) || other.paidFromAccountId == paidFromAccountId)&&(identical(other.walletAmountMinor, walletAmountMinor) || other.walletAmountMinor == walletAmountMinor)&&(identical(other.walletCurrency, walletCurrency) || other.walletCurrency == walletCurrency)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.fxRateMode, fxRateMode) || other.fxRateMode == fxRateMode)&&(identical(other.rateUpdatedAt, rateUpdatedAt) || other.rateUpdatedAt == rateUpdatedAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.client, client) || other.client == client)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other._tagIds, _tagIds)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.voidedAt, voidedAt) || other.voidedAt == voidedAt)&&(identical(other.voidReason, voidReason) || other.voidReason == voidReason)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,spaceId,title,totalMinor,currency,occurredOn,categoryId,method,const DeepCollectionEquality().hash(_payers),const DeepCollectionEquality().hash(_shares),const DeepCollectionEquality().hash(_items),cycleId,paidFromAccountId,walletAmountMinor,walletCurrency,exchangeRate,fxRateMode,rateUpdatedAt,source,client,status,note,const DeepCollectionEquality().hash(_tagIds),const DeepCollectionEquality().hash(_attachments),createdByUserId,voidedAt,voidReason,version]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SharedExpense(id: $id, spaceId: $spaceId, title: $title, totalMinor: $totalMinor, currency: $currency, occurredOn: $occurredOn, categoryId: $categoryId, method: $method, payers: $payers, shares: $shares, items: $items, cycleId: $cycleId, paidFromAccountId: $paidFromAccountId, walletAmountMinor: $walletAmountMinor, walletCurrency: $walletCurrency, exchangeRate: $exchangeRate, fxRateMode: $fxRateMode, rateUpdatedAt: $rateUpdatedAt, source: $source, client: $client, status: $status, note: $note, tagIds: $tagIds, attachments: $attachments, createdByUserId: $createdByUserId, voidedAt: $voidedAt, voidReason: $voidReason, version: $version)';
}


}

/// @nodoc
abstract mixin class _$SharedExpenseCopyWith<$Res> implements $SharedExpenseCopyWith<$Res> {
  factory _$SharedExpenseCopyWith(_SharedExpense value, $Res Function(_SharedExpense) _then) = __$SharedExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id, String spaceId, String title, int totalMinor, String currency, DateTime occurredOn, String categoryId, SplitMethod method, List<ExpensePayer> payers, List<SplitShare> shares, List<SplitItem> items, String cycleId, String? paidFromAccountId, int? walletAmountMinor, String? walletCurrency, double? exchangeRate, FxRateMode? fxRateMode, DateTime? rateUpdatedAt, String source, String? client, RecordStatus status, String note, List<String> tagIds, List<ReceiptAttachment> attachments, String createdByUserId, DateTime? voidedAt, String? voidReason, int version
});




}
/// @nodoc
class __$SharedExpenseCopyWithImpl<$Res>
    implements _$SharedExpenseCopyWith<$Res> {
  __$SharedExpenseCopyWithImpl(this._self, this._then);

  final _SharedExpense _self;
  final $Res Function(_SharedExpense) _then;

/// Create a copy of SharedExpense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = null,Object? title = null,Object? totalMinor = null,Object? currency = null,Object? occurredOn = null,Object? categoryId = null,Object? method = null,Object? payers = null,Object? shares = null,Object? items = null,Object? cycleId = null,Object? paidFromAccountId = freezed,Object? walletAmountMinor = freezed,Object? walletCurrency = freezed,Object? exchangeRate = freezed,Object? fxRateMode = freezed,Object? rateUpdatedAt = freezed,Object? source = null,Object? client = freezed,Object? status = null,Object? note = null,Object? tagIds = null,Object? attachments = null,Object? createdByUserId = null,Object? voidedAt = freezed,Object? voidReason = freezed,Object? version = null,}) {
  return _then(_SharedExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as SplitMethod,payers: null == payers ? _self._payers : payers // ignore: cast_nullable_to_non_nullable
as List<ExpensePayer>,shares: null == shares ? _self._shares : shares // ignore: cast_nullable_to_non_nullable
as List<SplitShare>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SplitItem>,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String,paidFromAccountId: freezed == paidFromAccountId ? _self.paidFromAccountId : paidFromAccountId // ignore: cast_nullable_to_non_nullable
as String?,walletAmountMinor: freezed == walletAmountMinor ? _self.walletAmountMinor : walletAmountMinor // ignore: cast_nullable_to_non_nullable
as int?,walletCurrency: freezed == walletCurrency ? _self.walletCurrency : walletCurrency // ignore: cast_nullable_to_non_nullable
as String?,exchangeRate: freezed == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double?,fxRateMode: freezed == fxRateMode ? _self.fxRateMode : fxRateMode // ignore: cast_nullable_to_non_nullable
as FxRateMode?,rateUpdatedAt: freezed == rateUpdatedAt ? _self.rateUpdatedAt : rateUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecordStatus,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,tagIds: null == tagIds ? _self._tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ReceiptAttachment>,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,voidedAt: freezed == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,voidReason: freezed == voidReason ? _self.voidReason : voidReason // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$MoneyTransaction implements DiagnosticableTreeMixin {

 String get id; MoneyEventType get type; int get amountMinor; String get currency; DateTime get occurredOn; String get merchant; String? get fromAccountId; String? get toAccountId; String? get categoryId; String? get splitId; String? get settlementId; String? get subscriptionId; int? get sourceAmountMinor; String? get sourceCurrency; int? get destinationAmountMinor; String? get destinationCurrency; double? get exchangeRate; FxRateMode? get fxRateMode; DateTime? get rateUpdatedAt; int get feeMinor; String? get feeCurrency; String get source; String? get client; RecordStatus get status;/// Why, in the user's words. `merchant` says what it was; this says why.
 String get note; List<String> get tagIds; String? get paymentMethodId; List<ReceiptAttachment> get attachments; String? get adjustmentReason; DateTime? get voidedAt; String? get voidReason; int get version;
/// Create a copy of MoneyTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoneyTransactionCopyWith<MoneyTransaction> get copyWith => _$MoneyTransactionCopyWithImpl<MoneyTransaction>(this as MoneyTransaction, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MoneyTransaction'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('occurredOn', occurredOn))..add(DiagnosticsProperty('merchant', merchant))..add(DiagnosticsProperty('fromAccountId', fromAccountId))..add(DiagnosticsProperty('toAccountId', toAccountId))..add(DiagnosticsProperty('categoryId', categoryId))..add(DiagnosticsProperty('splitId', splitId))..add(DiagnosticsProperty('settlementId', settlementId))..add(DiagnosticsProperty('subscriptionId', subscriptionId))..add(DiagnosticsProperty('sourceAmountMinor', sourceAmountMinor))..add(DiagnosticsProperty('sourceCurrency', sourceCurrency))..add(DiagnosticsProperty('destinationAmountMinor', destinationAmountMinor))..add(DiagnosticsProperty('destinationCurrency', destinationCurrency))..add(DiagnosticsProperty('exchangeRate', exchangeRate))..add(DiagnosticsProperty('fxRateMode', fxRateMode))..add(DiagnosticsProperty('rateUpdatedAt', rateUpdatedAt))..add(DiagnosticsProperty('feeMinor', feeMinor))..add(DiagnosticsProperty('feeCurrency', feeCurrency))..add(DiagnosticsProperty('source', source))..add(DiagnosticsProperty('client', client))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('tagIds', tagIds))..add(DiagnosticsProperty('paymentMethodId', paymentMethodId))..add(DiagnosticsProperty('attachments', attachments))..add(DiagnosticsProperty('adjustmentReason', adjustmentReason))..add(DiagnosticsProperty('voidedAt', voidedAt))..add(DiagnosticsProperty('voidReason', voidReason))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoneyTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.fromAccountId, fromAccountId) || other.fromAccountId == fromAccountId)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.splitId, splitId) || other.splitId == splitId)&&(identical(other.settlementId, settlementId) || other.settlementId == settlementId)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.sourceAmountMinor, sourceAmountMinor) || other.sourceAmountMinor == sourceAmountMinor)&&(identical(other.sourceCurrency, sourceCurrency) || other.sourceCurrency == sourceCurrency)&&(identical(other.destinationAmountMinor, destinationAmountMinor) || other.destinationAmountMinor == destinationAmountMinor)&&(identical(other.destinationCurrency, destinationCurrency) || other.destinationCurrency == destinationCurrency)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.fxRateMode, fxRateMode) || other.fxRateMode == fxRateMode)&&(identical(other.rateUpdatedAt, rateUpdatedAt) || other.rateUpdatedAt == rateUpdatedAt)&&(identical(other.feeMinor, feeMinor) || other.feeMinor == feeMinor)&&(identical(other.feeCurrency, feeCurrency) || other.feeCurrency == feeCurrency)&&(identical(other.source, source) || other.source == source)&&(identical(other.client, client) || other.client == client)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other.tagIds, tagIds)&&(identical(other.paymentMethodId, paymentMethodId) || other.paymentMethodId == paymentMethodId)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.adjustmentReason, adjustmentReason) || other.adjustmentReason == adjustmentReason)&&(identical(other.voidedAt, voidedAt) || other.voidedAt == voidedAt)&&(identical(other.voidReason, voidReason) || other.voidReason == voidReason)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,type,amountMinor,currency,occurredOn,merchant,fromAccountId,toAccountId,categoryId,splitId,settlementId,subscriptionId,sourceAmountMinor,sourceCurrency,destinationAmountMinor,destinationCurrency,exchangeRate,fxRateMode,rateUpdatedAt,feeMinor,feeCurrency,source,client,status,note,const DeepCollectionEquality().hash(tagIds),paymentMethodId,const DeepCollectionEquality().hash(attachments),adjustmentReason,voidedAt,voidReason,version]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MoneyTransaction(id: $id, type: $type, amountMinor: $amountMinor, currency: $currency, occurredOn: $occurredOn, merchant: $merchant, fromAccountId: $fromAccountId, toAccountId: $toAccountId, categoryId: $categoryId, splitId: $splitId, settlementId: $settlementId, subscriptionId: $subscriptionId, sourceAmountMinor: $sourceAmountMinor, sourceCurrency: $sourceCurrency, destinationAmountMinor: $destinationAmountMinor, destinationCurrency: $destinationCurrency, exchangeRate: $exchangeRate, fxRateMode: $fxRateMode, rateUpdatedAt: $rateUpdatedAt, feeMinor: $feeMinor, feeCurrency: $feeCurrency, source: $source, client: $client, status: $status, note: $note, tagIds: $tagIds, paymentMethodId: $paymentMethodId, attachments: $attachments, adjustmentReason: $adjustmentReason, voidedAt: $voidedAt, voidReason: $voidReason, version: $version)';
}


}

/// @nodoc
abstract mixin class $MoneyTransactionCopyWith<$Res>  {
  factory $MoneyTransactionCopyWith(MoneyTransaction value, $Res Function(MoneyTransaction) _then) = _$MoneyTransactionCopyWithImpl;
@useResult
$Res call({
 String id, MoneyEventType type, int amountMinor, String currency, DateTime occurredOn, String merchant, String? fromAccountId, String? toAccountId, String? categoryId, String? splitId, String? settlementId, String? subscriptionId, int? sourceAmountMinor, String? sourceCurrency, int? destinationAmountMinor, String? destinationCurrency, double? exchangeRate, FxRateMode? fxRateMode, DateTime? rateUpdatedAt, int feeMinor, String? feeCurrency, String source, String? client, RecordStatus status, String note, List<String> tagIds, String? paymentMethodId, List<ReceiptAttachment> attachments, String? adjustmentReason, DateTime? voidedAt, String? voidReason, int version
});




}
/// @nodoc
class _$MoneyTransactionCopyWithImpl<$Res>
    implements $MoneyTransactionCopyWith<$Res> {
  _$MoneyTransactionCopyWithImpl(this._self, this._then);

  final MoneyTransaction _self;
  final $Res Function(MoneyTransaction) _then;

/// Create a copy of MoneyTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amountMinor = null,Object? currency = null,Object? occurredOn = null,Object? merchant = null,Object? fromAccountId = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? splitId = freezed,Object? settlementId = freezed,Object? subscriptionId = freezed,Object? sourceAmountMinor = freezed,Object? sourceCurrency = freezed,Object? destinationAmountMinor = freezed,Object? destinationCurrency = freezed,Object? exchangeRate = freezed,Object? fxRateMode = freezed,Object? rateUpdatedAt = freezed,Object? feeMinor = null,Object? feeCurrency = freezed,Object? source = null,Object? client = freezed,Object? status = null,Object? note = null,Object? tagIds = null,Object? paymentMethodId = freezed,Object? attachments = null,Object? adjustmentReason = freezed,Object? voidedAt = freezed,Object? voidReason = freezed,Object? version = null,}) {
  return _then(MoneyTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MoneyEventType,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,merchant: null == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String,fromAccountId: freezed == fromAccountId ? _self.fromAccountId : fromAccountId // ignore: cast_nullable_to_non_nullable
as String?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,splitId: freezed == splitId ? _self.splitId : splitId // ignore: cast_nullable_to_non_nullable
as String?,settlementId: freezed == settlementId ? _self.settlementId : settlementId // ignore: cast_nullable_to_non_nullable
as String?,subscriptionId: freezed == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String?,sourceAmountMinor: freezed == sourceAmountMinor ? _self.sourceAmountMinor : sourceAmountMinor // ignore: cast_nullable_to_non_nullable
as int?,sourceCurrency: freezed == sourceCurrency ? _self.sourceCurrency : sourceCurrency // ignore: cast_nullable_to_non_nullable
as String?,destinationAmountMinor: freezed == destinationAmountMinor ? _self.destinationAmountMinor : destinationAmountMinor // ignore: cast_nullable_to_non_nullable
as int?,destinationCurrency: freezed == destinationCurrency ? _self.destinationCurrency : destinationCurrency // ignore: cast_nullable_to_non_nullable
as String?,exchangeRate: freezed == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double?,fxRateMode: freezed == fxRateMode ? _self.fxRateMode : fxRateMode // ignore: cast_nullable_to_non_nullable
as FxRateMode?,rateUpdatedAt: freezed == rateUpdatedAt ? _self.rateUpdatedAt : rateUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,feeMinor: null == feeMinor ? _self.feeMinor : feeMinor // ignore: cast_nullable_to_non_nullable
as int,feeCurrency: freezed == feeCurrency ? _self.feeCurrency : feeCurrency // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecordStatus,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,tagIds: null == tagIds ? _self.tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,paymentMethodId: freezed == paymentMethodId ? _self.paymentMethodId : paymentMethodId // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ReceiptAttachment>,adjustmentReason: freezed == adjustmentReason ? _self.adjustmentReason : adjustmentReason // ignore: cast_nullable_to_non_nullable
as String?,voidedAt: freezed == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,voidReason: freezed == voidReason ? _self.voidReason : voidReason // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MoneyTransaction].
extension MoneyTransactionPatterns on MoneyTransaction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MoneyTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MoneyTransaction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MoneyTransaction value)  $default,){
final _that = this;
switch (_that) {
case _MoneyTransaction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MoneyTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _MoneyTransaction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MoneyEventType type,  int amountMinor,  String currency,  DateTime occurredOn,  String merchant,  String? fromAccountId,  String? toAccountId,  String? categoryId,  String? splitId,  String? settlementId,  String? subscriptionId,  int? sourceAmountMinor,  String? sourceCurrency,  int? destinationAmountMinor,  String? destinationCurrency,  double? exchangeRate,  FxRateMode? fxRateMode,  DateTime? rateUpdatedAt,  int feeMinor,  String? feeCurrency,  String source,  String? client,  RecordStatus status,  String note,  List<String> tagIds,  String? paymentMethodId,  List<ReceiptAttachment> attachments,  String? adjustmentReason,  DateTime? voidedAt,  String? voidReason,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MoneyTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amountMinor,_that.currency,_that.occurredOn,_that.merchant,_that.fromAccountId,_that.toAccountId,_that.categoryId,_that.splitId,_that.settlementId,_that.subscriptionId,_that.sourceAmountMinor,_that.sourceCurrency,_that.destinationAmountMinor,_that.destinationCurrency,_that.exchangeRate,_that.fxRateMode,_that.rateUpdatedAt,_that.feeMinor,_that.feeCurrency,_that.source,_that.client,_that.status,_that.note,_that.tagIds,_that.paymentMethodId,_that.attachments,_that.adjustmentReason,_that.voidedAt,_that.voidReason,_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MoneyEventType type,  int amountMinor,  String currency,  DateTime occurredOn,  String merchant,  String? fromAccountId,  String? toAccountId,  String? categoryId,  String? splitId,  String? settlementId,  String? subscriptionId,  int? sourceAmountMinor,  String? sourceCurrency,  int? destinationAmountMinor,  String? destinationCurrency,  double? exchangeRate,  FxRateMode? fxRateMode,  DateTime? rateUpdatedAt,  int feeMinor,  String? feeCurrency,  String source,  String? client,  RecordStatus status,  String note,  List<String> tagIds,  String? paymentMethodId,  List<ReceiptAttachment> attachments,  String? adjustmentReason,  DateTime? voidedAt,  String? voidReason,  int version)  $default,) {final _that = this;
switch (_that) {
case _MoneyTransaction():
return $default(_that.id,_that.type,_that.amountMinor,_that.currency,_that.occurredOn,_that.merchant,_that.fromAccountId,_that.toAccountId,_that.categoryId,_that.splitId,_that.settlementId,_that.subscriptionId,_that.sourceAmountMinor,_that.sourceCurrency,_that.destinationAmountMinor,_that.destinationCurrency,_that.exchangeRate,_that.fxRateMode,_that.rateUpdatedAt,_that.feeMinor,_that.feeCurrency,_that.source,_that.client,_that.status,_that.note,_that.tagIds,_that.paymentMethodId,_that.attachments,_that.adjustmentReason,_that.voidedAt,_that.voidReason,_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MoneyEventType type,  int amountMinor,  String currency,  DateTime occurredOn,  String merchant,  String? fromAccountId,  String? toAccountId,  String? categoryId,  String? splitId,  String? settlementId,  String? subscriptionId,  int? sourceAmountMinor,  String? sourceCurrency,  int? destinationAmountMinor,  String? destinationCurrency,  double? exchangeRate,  FxRateMode? fxRateMode,  DateTime? rateUpdatedAt,  int feeMinor,  String? feeCurrency,  String source,  String? client,  RecordStatus status,  String note,  List<String> tagIds,  String? paymentMethodId,  List<ReceiptAttachment> attachments,  String? adjustmentReason,  DateTime? voidedAt,  String? voidReason,  int version)?  $default,) {final _that = this;
switch (_that) {
case _MoneyTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amountMinor,_that.currency,_that.occurredOn,_that.merchant,_that.fromAccountId,_that.toAccountId,_that.categoryId,_that.splitId,_that.settlementId,_that.subscriptionId,_that.sourceAmountMinor,_that.sourceCurrency,_that.destinationAmountMinor,_that.destinationCurrency,_that.exchangeRate,_that.fxRateMode,_that.rateUpdatedAt,_that.feeMinor,_that.feeCurrency,_that.source,_that.client,_that.status,_that.note,_that.tagIds,_that.paymentMethodId,_that.attachments,_that.adjustmentReason,_that.voidedAt,_that.voidReason,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _MoneyTransaction with DiagnosticableTreeMixin implements MoneyTransaction {
  const _MoneyTransaction({required this.id, required this.type, required this.amountMinor, required this.currency, required this.occurredOn, required this.merchant, this.fromAccountId, this.toAccountId, this.categoryId, this.splitId, this.settlementId, this.subscriptionId, this.sourceAmountMinor, this.sourceCurrency, this.destinationAmountMinor, this.destinationCurrency, this.exchangeRate, this.fxRateMode, this.rateUpdatedAt, this.feeMinor = 0, this.feeCurrency, this.source = 'mobile', this.client, this.status = RecordStatus.confirmed, this.note = '',  List<String> tagIds = const <String>[], this.paymentMethodId,  List<ReceiptAttachment> attachments = const <ReceiptAttachment>[], this.adjustmentReason, this.voidedAt, this.voidReason, this.version = 1}): _tagIds = tagIds,_attachments = attachments;
  

@override final  String id;
@override final  MoneyEventType type;
@override final  int amountMinor;
@override final  String currency;
@override final  DateTime occurredOn;
@override final  String merchant;
@override final  String? fromAccountId;
@override final  String? toAccountId;
@override final  String? categoryId;
@override final  String? splitId;
@override final  String? settlementId;
@override final  String? subscriptionId;
@override final  int? sourceAmountMinor;
@override final  String? sourceCurrency;
@override final  int? destinationAmountMinor;
@override final  String? destinationCurrency;
@override final  double? exchangeRate;
@override final  FxRateMode? fxRateMode;
@override final  DateTime? rateUpdatedAt;
@override@JsonKey() final  int feeMinor;
@override final  String? feeCurrency;
@override@JsonKey() final  String source;
@override final  String? client;
@override@JsonKey() final  RecordStatus status;
/// Why, in the user's words. `merchant` says what it was; this says why.
@override@JsonKey() final  String note;
 final  List<String> _tagIds;
@override@JsonKey() List<String> get tagIds {
  if (_tagIds is EqualUnmodifiableListView) return _tagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagIds);
}

@override final  String? paymentMethodId;
 final  List<ReceiptAttachment> _attachments;
@override@JsonKey() List<ReceiptAttachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override final  String? adjustmentReason;
@override final  DateTime? voidedAt;
@override final  String? voidReason;
@override@JsonKey() final  int version;

/// Create a copy of MoneyTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoneyTransactionCopyWith<_MoneyTransaction> get copyWith => __$MoneyTransactionCopyWithImpl<_MoneyTransaction>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MoneyTransaction'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('occurredOn', occurredOn))..add(DiagnosticsProperty('merchant', merchant))..add(DiagnosticsProperty('fromAccountId', fromAccountId))..add(DiagnosticsProperty('toAccountId', toAccountId))..add(DiagnosticsProperty('categoryId', categoryId))..add(DiagnosticsProperty('splitId', splitId))..add(DiagnosticsProperty('settlementId', settlementId))..add(DiagnosticsProperty('subscriptionId', subscriptionId))..add(DiagnosticsProperty('sourceAmountMinor', sourceAmountMinor))..add(DiagnosticsProperty('sourceCurrency', sourceCurrency))..add(DiagnosticsProperty('destinationAmountMinor', destinationAmountMinor))..add(DiagnosticsProperty('destinationCurrency', destinationCurrency))..add(DiagnosticsProperty('exchangeRate', exchangeRate))..add(DiagnosticsProperty('fxRateMode', fxRateMode))..add(DiagnosticsProperty('rateUpdatedAt', rateUpdatedAt))..add(DiagnosticsProperty('feeMinor', feeMinor))..add(DiagnosticsProperty('feeCurrency', feeCurrency))..add(DiagnosticsProperty('source', source))..add(DiagnosticsProperty('client', client))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('tagIds', tagIds))..add(DiagnosticsProperty('paymentMethodId', paymentMethodId))..add(DiagnosticsProperty('attachments', attachments))..add(DiagnosticsProperty('adjustmentReason', adjustmentReason))..add(DiagnosticsProperty('voidedAt', voidedAt))..add(DiagnosticsProperty('voidReason', voidReason))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MoneyTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.fromAccountId, fromAccountId) || other.fromAccountId == fromAccountId)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.splitId, splitId) || other.splitId == splitId)&&(identical(other.settlementId, settlementId) || other.settlementId == settlementId)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.sourceAmountMinor, sourceAmountMinor) || other.sourceAmountMinor == sourceAmountMinor)&&(identical(other.sourceCurrency, sourceCurrency) || other.sourceCurrency == sourceCurrency)&&(identical(other.destinationAmountMinor, destinationAmountMinor) || other.destinationAmountMinor == destinationAmountMinor)&&(identical(other.destinationCurrency, destinationCurrency) || other.destinationCurrency == destinationCurrency)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.fxRateMode, fxRateMode) || other.fxRateMode == fxRateMode)&&(identical(other.rateUpdatedAt, rateUpdatedAt) || other.rateUpdatedAt == rateUpdatedAt)&&(identical(other.feeMinor, feeMinor) || other.feeMinor == feeMinor)&&(identical(other.feeCurrency, feeCurrency) || other.feeCurrency == feeCurrency)&&(identical(other.source, source) || other.source == source)&&(identical(other.client, client) || other.client == client)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other._tagIds, _tagIds)&&(identical(other.paymentMethodId, paymentMethodId) || other.paymentMethodId == paymentMethodId)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.adjustmentReason, adjustmentReason) || other.adjustmentReason == adjustmentReason)&&(identical(other.voidedAt, voidedAt) || other.voidedAt == voidedAt)&&(identical(other.voidReason, voidReason) || other.voidReason == voidReason)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,type,amountMinor,currency,occurredOn,merchant,fromAccountId,toAccountId,categoryId,splitId,settlementId,subscriptionId,sourceAmountMinor,sourceCurrency,destinationAmountMinor,destinationCurrency,exchangeRate,fxRateMode,rateUpdatedAt,feeMinor,feeCurrency,source,client,status,note,const DeepCollectionEquality().hash(_tagIds),paymentMethodId,const DeepCollectionEquality().hash(_attachments),adjustmentReason,voidedAt,voidReason,version]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MoneyTransaction(id: $id, type: $type, amountMinor: $amountMinor, currency: $currency, occurredOn: $occurredOn, merchant: $merchant, fromAccountId: $fromAccountId, toAccountId: $toAccountId, categoryId: $categoryId, splitId: $splitId, settlementId: $settlementId, subscriptionId: $subscriptionId, sourceAmountMinor: $sourceAmountMinor, sourceCurrency: $sourceCurrency, destinationAmountMinor: $destinationAmountMinor, destinationCurrency: $destinationCurrency, exchangeRate: $exchangeRate, fxRateMode: $fxRateMode, rateUpdatedAt: $rateUpdatedAt, feeMinor: $feeMinor, feeCurrency: $feeCurrency, source: $source, client: $client, status: $status, note: $note, tagIds: $tagIds, paymentMethodId: $paymentMethodId, attachments: $attachments, adjustmentReason: $adjustmentReason, voidedAt: $voidedAt, voidReason: $voidReason, version: $version)';
}


}

/// @nodoc
abstract mixin class _$MoneyTransactionCopyWith<$Res> implements $MoneyTransactionCopyWith<$Res> {
  factory _$MoneyTransactionCopyWith(_MoneyTransaction value, $Res Function(_MoneyTransaction) _then) = __$MoneyTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, MoneyEventType type, int amountMinor, String currency, DateTime occurredOn, String merchant, String? fromAccountId, String? toAccountId, String? categoryId, String? splitId, String? settlementId, String? subscriptionId, int? sourceAmountMinor, String? sourceCurrency, int? destinationAmountMinor, String? destinationCurrency, double? exchangeRate, FxRateMode? fxRateMode, DateTime? rateUpdatedAt, int feeMinor, String? feeCurrency, String source, String? client, RecordStatus status, String note, List<String> tagIds, String? paymentMethodId, List<ReceiptAttachment> attachments, String? adjustmentReason, DateTime? voidedAt, String? voidReason, int version
});




}
/// @nodoc
class __$MoneyTransactionCopyWithImpl<$Res>
    implements _$MoneyTransactionCopyWith<$Res> {
  __$MoneyTransactionCopyWithImpl(this._self, this._then);

  final _MoneyTransaction _self;
  final $Res Function(_MoneyTransaction) _then;

/// Create a copy of MoneyTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amountMinor = null,Object? currency = null,Object? occurredOn = null,Object? merchant = null,Object? fromAccountId = freezed,Object? toAccountId = freezed,Object? categoryId = freezed,Object? splitId = freezed,Object? settlementId = freezed,Object? subscriptionId = freezed,Object? sourceAmountMinor = freezed,Object? sourceCurrency = freezed,Object? destinationAmountMinor = freezed,Object? destinationCurrency = freezed,Object? exchangeRate = freezed,Object? fxRateMode = freezed,Object? rateUpdatedAt = freezed,Object? feeMinor = null,Object? feeCurrency = freezed,Object? source = null,Object? client = freezed,Object? status = null,Object? note = null,Object? tagIds = null,Object? paymentMethodId = freezed,Object? attachments = null,Object? adjustmentReason = freezed,Object? voidedAt = freezed,Object? voidReason = freezed,Object? version = null,}) {
  return _then(_MoneyTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MoneyEventType,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,merchant: null == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String,fromAccountId: freezed == fromAccountId ? _self.fromAccountId : fromAccountId // ignore: cast_nullable_to_non_nullable
as String?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,splitId: freezed == splitId ? _self.splitId : splitId // ignore: cast_nullable_to_non_nullable
as String?,settlementId: freezed == settlementId ? _self.settlementId : settlementId // ignore: cast_nullable_to_non_nullable
as String?,subscriptionId: freezed == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String?,sourceAmountMinor: freezed == sourceAmountMinor ? _self.sourceAmountMinor : sourceAmountMinor // ignore: cast_nullable_to_non_nullable
as int?,sourceCurrency: freezed == sourceCurrency ? _self.sourceCurrency : sourceCurrency // ignore: cast_nullable_to_non_nullable
as String?,destinationAmountMinor: freezed == destinationAmountMinor ? _self.destinationAmountMinor : destinationAmountMinor // ignore: cast_nullable_to_non_nullable
as int?,destinationCurrency: freezed == destinationCurrency ? _self.destinationCurrency : destinationCurrency // ignore: cast_nullable_to_non_nullable
as String?,exchangeRate: freezed == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as double?,fxRateMode: freezed == fxRateMode ? _self.fxRateMode : fxRateMode // ignore: cast_nullable_to_non_nullable
as FxRateMode?,rateUpdatedAt: freezed == rateUpdatedAt ? _self.rateUpdatedAt : rateUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,feeMinor: null == feeMinor ? _self.feeMinor : feeMinor // ignore: cast_nullable_to_non_nullable
as int,feeCurrency: freezed == feeCurrency ? _self.feeCurrency : feeCurrency // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecordStatus,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,tagIds: null == tagIds ? _self._tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,paymentMethodId: freezed == paymentMethodId ? _self.paymentMethodId : paymentMethodId // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<ReceiptAttachment>,adjustmentReason: freezed == adjustmentReason ? _self.adjustmentReason : adjustmentReason // ignore: cast_nullable_to_non_nullable
as String?,voidedAt: freezed == voidedAt ? _self.voidedAt : voidedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,voidReason: freezed == voidReason ? _self.voidReason : voidReason // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Settlement implements DiagnosticableTreeMixin {

 String get id; String get spaceId; String get fromUserId; String get toUserId; int get amountMinor; String get currency; DateTime get createdAt; DateTime? get settledAt; SettlementStatus get status; String get note; String get source; String get cycleId;/// Who proposed it. The other side is the one who can confirm.
 String get proposedByUserId; String? get confirmedByUserId; String? get cancelledByUserId; DateTime? get cancelledAt; String? get cancelReason; int get version;
/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementCopyWith<Settlement> get copyWith => _$SettlementCopyWithImpl<Settlement>(this as Settlement, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Settlement'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('fromUserId', fromUserId))..add(DiagnosticsProperty('toUserId', toUserId))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('settledAt', settledAt))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('source', source))..add(DiagnosticsProperty('cycleId', cycleId))..add(DiagnosticsProperty('proposedByUserId', proposedByUserId))..add(DiagnosticsProperty('confirmedByUserId', confirmedByUserId))..add(DiagnosticsProperty('cancelledByUserId', cancelledByUserId))..add(DiagnosticsProperty('cancelledAt', cancelledAt))..add(DiagnosticsProperty('cancelReason', cancelReason))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settlement&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.settledAt, settledAt) || other.settledAt == settledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.source, source) || other.source == source)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.proposedByUserId, proposedByUserId) || other.proposedByUserId == proposedByUserId)&&(identical(other.confirmedByUserId, confirmedByUserId) || other.confirmedByUserId == confirmedByUserId)&&(identical(other.cancelledByUserId, cancelledByUserId) || other.cancelledByUserId == cancelledByUserId)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,fromUserId,toUserId,amountMinor,currency,createdAt,settledAt,status,note,source,cycleId,proposedByUserId,confirmedByUserId,cancelledByUserId,cancelledAt,cancelReason,version);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Settlement(id: $id, spaceId: $spaceId, fromUserId: $fromUserId, toUserId: $toUserId, amountMinor: $amountMinor, currency: $currency, createdAt: $createdAt, settledAt: $settledAt, status: $status, note: $note, source: $source, cycleId: $cycleId, proposedByUserId: $proposedByUserId, confirmedByUserId: $confirmedByUserId, cancelledByUserId: $cancelledByUserId, cancelledAt: $cancelledAt, cancelReason: $cancelReason, version: $version)';
}


}

/// @nodoc
abstract mixin class $SettlementCopyWith<$Res>  {
  factory $SettlementCopyWith(Settlement value, $Res Function(Settlement) _then) = _$SettlementCopyWithImpl;
@useResult
$Res call({
 String id, String spaceId, String fromUserId, String toUserId, int amountMinor, String currency, DateTime createdAt, DateTime? settledAt, SettlementStatus status, String note, String source, String cycleId, String proposedByUserId, String? confirmedByUserId, String? cancelledByUserId, DateTime? cancelledAt, String? cancelReason, int version
});




}
/// @nodoc
class _$SettlementCopyWithImpl<$Res>
    implements $SettlementCopyWith<$Res> {
  _$SettlementCopyWithImpl(this._self, this._then);

  final Settlement _self;
  final $Res Function(Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = null,Object? fromUserId = null,Object? toUserId = null,Object? amountMinor = null,Object? currency = null,Object? createdAt = null,Object? settledAt = freezed,Object? status = null,Object? note = null,Object? source = null,Object? cycleId = null,Object? proposedByUserId = null,Object? confirmedByUserId = freezed,Object? cancelledByUserId = freezed,Object? cancelledAt = freezed,Object? cancelReason = freezed,Object? version = null,}) {
  return _then(Settlement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,settledAt: freezed == settledAt ? _self.settledAt : settledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SettlementStatus,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String,proposedByUserId: null == proposedByUserId ? _self.proposedByUserId : proposedByUserId // ignore: cast_nullable_to_non_nullable
as String,confirmedByUserId: freezed == confirmedByUserId ? _self.confirmedByUserId : confirmedByUserId // ignore: cast_nullable_to_non_nullable
as String?,cancelledByUserId: freezed == cancelledByUserId ? _self.cancelledByUserId : cancelledByUserId // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Settlement].
extension SettlementPatterns on Settlement {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settlement value)  $default,){
final _that = this;
switch (_that) {
case _Settlement():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settlement value)?  $default,){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String spaceId,  String fromUserId,  String toUserId,  int amountMinor,  String currency,  DateTime createdAt,  DateTime? settledAt,  SettlementStatus status,  String note,  String source,  String cycleId,  String proposedByUserId,  String? confirmedByUserId,  String? cancelledByUserId,  DateTime? cancelledAt,  String? cancelReason,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.id,_that.spaceId,_that.fromUserId,_that.toUserId,_that.amountMinor,_that.currency,_that.createdAt,_that.settledAt,_that.status,_that.note,_that.source,_that.cycleId,_that.proposedByUserId,_that.confirmedByUserId,_that.cancelledByUserId,_that.cancelledAt,_that.cancelReason,_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String spaceId,  String fromUserId,  String toUserId,  int amountMinor,  String currency,  DateTime createdAt,  DateTime? settledAt,  SettlementStatus status,  String note,  String source,  String cycleId,  String proposedByUserId,  String? confirmedByUserId,  String? cancelledByUserId,  DateTime? cancelledAt,  String? cancelReason,  int version)  $default,) {final _that = this;
switch (_that) {
case _Settlement():
return $default(_that.id,_that.spaceId,_that.fromUserId,_that.toUserId,_that.amountMinor,_that.currency,_that.createdAt,_that.settledAt,_that.status,_that.note,_that.source,_that.cycleId,_that.proposedByUserId,_that.confirmedByUserId,_that.cancelledByUserId,_that.cancelledAt,_that.cancelReason,_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String spaceId,  String fromUserId,  String toUserId,  int amountMinor,  String currency,  DateTime createdAt,  DateTime? settledAt,  SettlementStatus status,  String note,  String source,  String cycleId,  String proposedByUserId,  String? confirmedByUserId,  String? cancelledByUserId,  DateTime? cancelledAt,  String? cancelReason,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.id,_that.spaceId,_that.fromUserId,_that.toUserId,_that.amountMinor,_that.currency,_that.createdAt,_that.settledAt,_that.status,_that.note,_that.source,_that.cycleId,_that.proposedByUserId,_that.confirmedByUserId,_that.cancelledByUserId,_that.cancelledAt,_that.cancelReason,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _Settlement with DiagnosticableTreeMixin implements Settlement {
  const _Settlement({required this.id, required this.spaceId, required this.fromUserId, required this.toUserId, required this.amountMinor, required this.currency, required this.createdAt, this.settledAt, this.status = SettlementStatus.proposed, this.note = '', this.source = 'mobile', this.cycleId = 'current', this.proposedByUserId = '', this.confirmedByUserId, this.cancelledByUserId, this.cancelledAt, this.cancelReason, this.version = 1});
  

@override final  String id;
@override final  String spaceId;
@override final  String fromUserId;
@override final  String toUserId;
@override final  int amountMinor;
@override final  String currency;
@override final  DateTime createdAt;
@override final  DateTime? settledAt;
@override@JsonKey() final  SettlementStatus status;
@override@JsonKey() final  String note;
@override@JsonKey() final  String source;
@override@JsonKey() final  String cycleId;
/// Who proposed it. The other side is the one who can confirm.
@override@JsonKey() final  String proposedByUserId;
@override final  String? confirmedByUserId;
@override final  String? cancelledByUserId;
@override final  DateTime? cancelledAt;
@override final  String? cancelReason;
@override@JsonKey() final  int version;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementCopyWith<_Settlement> get copyWith => __$SettlementCopyWithImpl<_Settlement>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Settlement'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('fromUserId', fromUserId))..add(DiagnosticsProperty('toUserId', toUserId))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('settledAt', settledAt))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('source', source))..add(DiagnosticsProperty('cycleId', cycleId))..add(DiagnosticsProperty('proposedByUserId', proposedByUserId))..add(DiagnosticsProperty('confirmedByUserId', confirmedByUserId))..add(DiagnosticsProperty('cancelledByUserId', cancelledByUserId))..add(DiagnosticsProperty('cancelledAt', cancelledAt))..add(DiagnosticsProperty('cancelReason', cancelReason))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settlement&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.settledAt, settledAt) || other.settledAt == settledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.source, source) || other.source == source)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.proposedByUserId, proposedByUserId) || other.proposedByUserId == proposedByUserId)&&(identical(other.confirmedByUserId, confirmedByUserId) || other.confirmedByUserId == confirmedByUserId)&&(identical(other.cancelledByUserId, cancelledByUserId) || other.cancelledByUserId == cancelledByUserId)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,fromUserId,toUserId,amountMinor,currency,createdAt,settledAt,status,note,source,cycleId,proposedByUserId,confirmedByUserId,cancelledByUserId,cancelledAt,cancelReason,version);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Settlement(id: $id, spaceId: $spaceId, fromUserId: $fromUserId, toUserId: $toUserId, amountMinor: $amountMinor, currency: $currency, createdAt: $createdAt, settledAt: $settledAt, status: $status, note: $note, source: $source, cycleId: $cycleId, proposedByUserId: $proposedByUserId, confirmedByUserId: $confirmedByUserId, cancelledByUserId: $cancelledByUserId, cancelledAt: $cancelledAt, cancelReason: $cancelReason, version: $version)';
}


}

/// @nodoc
abstract mixin class _$SettlementCopyWith<$Res> implements $SettlementCopyWith<$Res> {
  factory _$SettlementCopyWith(_Settlement value, $Res Function(_Settlement) _then) = __$SettlementCopyWithImpl;
@override @useResult
$Res call({
 String id, String spaceId, String fromUserId, String toUserId, int amountMinor, String currency, DateTime createdAt, DateTime? settledAt, SettlementStatus status, String note, String source, String cycleId, String proposedByUserId, String? confirmedByUserId, String? cancelledByUserId, DateTime? cancelledAt, String? cancelReason, int version
});




}
/// @nodoc
class __$SettlementCopyWithImpl<$Res>
    implements _$SettlementCopyWith<$Res> {
  __$SettlementCopyWithImpl(this._self, this._then);

  final _Settlement _self;
  final $Res Function(_Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = null,Object? fromUserId = null,Object? toUserId = null,Object? amountMinor = null,Object? currency = null,Object? createdAt = null,Object? settledAt = freezed,Object? status = null,Object? note = null,Object? source = null,Object? cycleId = null,Object? proposedByUserId = null,Object? confirmedByUserId = freezed,Object? cancelledByUserId = freezed,Object? cancelledAt = freezed,Object? cancelReason = freezed,Object? version = null,}) {
  return _then(_Settlement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,settledAt: freezed == settledAt ? _self.settledAt : settledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SettlementStatus,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as String,proposedByUserId: null == proposedByUserId ? _self.proposedByUserId : proposedByUserId // ignore: cast_nullable_to_non_nullable
as String,confirmedByUserId: freezed == confirmedByUserId ? _self.confirmedByUserId : confirmedByUserId // ignore: cast_nullable_to_non_nullable
as String?,cancelledByUserId: freezed == cancelledByUserId ? _self.cancelledByUserId : cancelledByUserId // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Budget implements DiagnosticableTreeMixin {

 String get id; String get name; BudgetScope get scope; String get categoryId; int get limitMinor; String get currency; String? get spaceId; List<String> get categoryIds; List<String> get accountIds; DateTime? get startsOn; List<int> get alerts; BudgetPeriod get period;/// Length of a custom period, in days. Ignored for the named periods.
 int get customPeriodDays;/// Carries whatever was left of the last period into this one.
 bool get rollover; int get version;
/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetCopyWith<Budget> get copyWith => _$BudgetCopyWithImpl<Budget>(this as Budget, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Budget'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('scope', scope))..add(DiagnosticsProperty('categoryId', categoryId))..add(DiagnosticsProperty('limitMinor', limitMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('categoryIds', categoryIds))..add(DiagnosticsProperty('accountIds', accountIds))..add(DiagnosticsProperty('startsOn', startsOn))..add(DiagnosticsProperty('alerts', alerts))..add(DiagnosticsProperty('period', period))..add(DiagnosticsProperty('customPeriodDays', customPeriodDays))..add(DiagnosticsProperty('rollover', rollover))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Budget&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.limitMinor, limitMinor) || other.limitMinor == limitMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&const DeepCollectionEquality().equals(other.categoryIds, categoryIds)&&const DeepCollectionEquality().equals(other.accountIds, accountIds)&&(identical(other.startsOn, startsOn) || other.startsOn == startsOn)&&const DeepCollectionEquality().equals(other.alerts, alerts)&&(identical(other.period, period) || other.period == period)&&(identical(other.customPeriodDays, customPeriodDays) || other.customPeriodDays == customPeriodDays)&&(identical(other.rollover, rollover) || other.rollover == rollover)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,scope,categoryId,limitMinor,currency,spaceId,const DeepCollectionEquality().hash(categoryIds),const DeepCollectionEquality().hash(accountIds),startsOn,const DeepCollectionEquality().hash(alerts),period,customPeriodDays,rollover,version);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Budget(id: $id, name: $name, scope: $scope, categoryId: $categoryId, limitMinor: $limitMinor, currency: $currency, spaceId: $spaceId, categoryIds: $categoryIds, accountIds: $accountIds, startsOn: $startsOn, alerts: $alerts, period: $period, customPeriodDays: $customPeriodDays, rollover: $rollover, version: $version)';
}


}

/// @nodoc
abstract mixin class $BudgetCopyWith<$Res>  {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) _then) = _$BudgetCopyWithImpl;
@useResult
$Res call({
 String id, String name, BudgetScope scope, String categoryId, int limitMinor, String currency, String? spaceId, List<String> categoryIds, List<String> accountIds, DateTime? startsOn, List<int> alerts, BudgetPeriod period, int customPeriodDays, bool rollover, int version
});




}
/// @nodoc
class _$BudgetCopyWithImpl<$Res>
    implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._self, this._then);

  final Budget _self;
  final $Res Function(Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? scope = null,Object? categoryId = null,Object? limitMinor = null,Object? currency = null,Object? spaceId = freezed,Object? categoryIds = null,Object? accountIds = null,Object? startsOn = freezed,Object? alerts = null,Object? period = null,Object? customPeriodDays = null,Object? rollover = null,Object? version = null,}) {
  return _then(Budget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as BudgetScope,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,limitMinor: null == limitMinor ? _self.limitMinor : limitMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,categoryIds: null == categoryIds ? _self.categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,accountIds: null == accountIds ? _self.accountIds : accountIds // ignore: cast_nullable_to_non_nullable
as List<String>,startsOn: freezed == startsOn ? _self.startsOn : startsOn // ignore: cast_nullable_to_non_nullable
as DateTime?,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<int>,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as BudgetPeriod,customPeriodDays: null == customPeriodDays ? _self.customPeriodDays : customPeriodDays // ignore: cast_nullable_to_non_nullable
as int,rollover: null == rollover ? _self.rollover : rollover // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Budget].
extension BudgetPatterns on Budget {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Budget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Budget value)  $default,){
final _that = this;
switch (_that) {
case _Budget():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Budget value)?  $default,){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  BudgetScope scope,  String categoryId,  int limitMinor,  String currency,  String? spaceId,  List<String> categoryIds,  List<String> accountIds,  DateTime? startsOn,  List<int> alerts,  BudgetPeriod period,  int customPeriodDays,  bool rollover,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.id,_that.name,_that.scope,_that.categoryId,_that.limitMinor,_that.currency,_that.spaceId,_that.categoryIds,_that.accountIds,_that.startsOn,_that.alerts,_that.period,_that.customPeriodDays,_that.rollover,_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  BudgetScope scope,  String categoryId,  int limitMinor,  String currency,  String? spaceId,  List<String> categoryIds,  List<String> accountIds,  DateTime? startsOn,  List<int> alerts,  BudgetPeriod period,  int customPeriodDays,  bool rollover,  int version)  $default,) {final _that = this;
switch (_that) {
case _Budget():
return $default(_that.id,_that.name,_that.scope,_that.categoryId,_that.limitMinor,_that.currency,_that.spaceId,_that.categoryIds,_that.accountIds,_that.startsOn,_that.alerts,_that.period,_that.customPeriodDays,_that.rollover,_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  BudgetScope scope,  String categoryId,  int limitMinor,  String currency,  String? spaceId,  List<String> categoryIds,  List<String> accountIds,  DateTime? startsOn,  List<int> alerts,  BudgetPeriod period,  int customPeriodDays,  bool rollover,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.id,_that.name,_that.scope,_that.categoryId,_that.limitMinor,_that.currency,_that.spaceId,_that.categoryIds,_that.accountIds,_that.startsOn,_that.alerts,_that.period,_that.customPeriodDays,_that.rollover,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _Budget with DiagnosticableTreeMixin implements Budget {
  const _Budget({required this.id, required this.name, required this.scope, required this.categoryId, required this.limitMinor, required this.currency, this.spaceId,  List<String> categoryIds = const <String>[],  List<String> accountIds = const <String>[], this.startsOn,  List<int> alerts = const <int>[80, 100], this.period = BudgetPeriod.monthly, this.customPeriodDays = 30, this.rollover = false, this.version = 1}): _categoryIds = categoryIds,_accountIds = accountIds,_alerts = alerts;
  

@override final  String id;
@override final  String name;
@override final  BudgetScope scope;
@override final  String categoryId;
@override final  int limitMinor;
@override final  String currency;
@override final  String? spaceId;
 final  List<String> _categoryIds;
@override@JsonKey() List<String> get categoryIds {
  if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryIds);
}

 final  List<String> _accountIds;
@override@JsonKey() List<String> get accountIds {
  if (_accountIds is EqualUnmodifiableListView) return _accountIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accountIds);
}

@override final  DateTime? startsOn;
 final  List<int> _alerts;
@override@JsonKey() List<int> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}

@override@JsonKey() final  BudgetPeriod period;
/// Length of a custom period, in days. Ignored for the named periods.
@override@JsonKey() final  int customPeriodDays;
/// Carries whatever was left of the last period into this one.
@override@JsonKey() final  bool rollover;
@override@JsonKey() final  int version;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetCopyWith<_Budget> get copyWith => __$BudgetCopyWithImpl<_Budget>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Budget'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('scope', scope))..add(DiagnosticsProperty('categoryId', categoryId))..add(DiagnosticsProperty('limitMinor', limitMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('categoryIds', categoryIds))..add(DiagnosticsProperty('accountIds', accountIds))..add(DiagnosticsProperty('startsOn', startsOn))..add(DiagnosticsProperty('alerts', alerts))..add(DiagnosticsProperty('period', period))..add(DiagnosticsProperty('customPeriodDays', customPeriodDays))..add(DiagnosticsProperty('rollover', rollover))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Budget&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.limitMinor, limitMinor) || other.limitMinor == limitMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&const DeepCollectionEquality().equals(other._categoryIds, _categoryIds)&&const DeepCollectionEquality().equals(other._accountIds, _accountIds)&&(identical(other.startsOn, startsOn) || other.startsOn == startsOn)&&const DeepCollectionEquality().equals(other._alerts, _alerts)&&(identical(other.period, period) || other.period == period)&&(identical(other.customPeriodDays, customPeriodDays) || other.customPeriodDays == customPeriodDays)&&(identical(other.rollover, rollover) || other.rollover == rollover)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,scope,categoryId,limitMinor,currency,spaceId,const DeepCollectionEquality().hash(_categoryIds),const DeepCollectionEquality().hash(_accountIds),startsOn,const DeepCollectionEquality().hash(_alerts),period,customPeriodDays,rollover,version);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Budget(id: $id, name: $name, scope: $scope, categoryId: $categoryId, limitMinor: $limitMinor, currency: $currency, spaceId: $spaceId, categoryIds: $categoryIds, accountIds: $accountIds, startsOn: $startsOn, alerts: $alerts, period: $period, customPeriodDays: $customPeriodDays, rollover: $rollover, version: $version)';
}


}

/// @nodoc
abstract mixin class _$BudgetCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$BudgetCopyWith(_Budget value, $Res Function(_Budget) _then) = __$BudgetCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, BudgetScope scope, String categoryId, int limitMinor, String currency, String? spaceId, List<String> categoryIds, List<String> accountIds, DateTime? startsOn, List<int> alerts, BudgetPeriod period, int customPeriodDays, bool rollover, int version
});




}
/// @nodoc
class __$BudgetCopyWithImpl<$Res>
    implements _$BudgetCopyWith<$Res> {
  __$BudgetCopyWithImpl(this._self, this._then);

  final _Budget _self;
  final $Res Function(_Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? scope = null,Object? categoryId = null,Object? limitMinor = null,Object? currency = null,Object? spaceId = freezed,Object? categoryIds = null,Object? accountIds = null,Object? startsOn = freezed,Object? alerts = null,Object? period = null,Object? customPeriodDays = null,Object? rollover = null,Object? version = null,}) {
  return _then(_Budget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as BudgetScope,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,limitMinor: null == limitMinor ? _self.limitMinor : limitMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,categoryIds: null == categoryIds ? _self._categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as List<String>,accountIds: null == accountIds ? _self._accountIds : accountIds // ignore: cast_nullable_to_non_nullable
as List<String>,startsOn: freezed == startsOn ? _self.startsOn : startsOn // ignore: cast_nullable_to_non_nullable
as DateTime?,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<int>,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as BudgetPeriod,customPeriodDays: null == customPeriodDays ? _self.customPeriodDays : customPeriodDays // ignore: cast_nullable_to_non_nullable
as int,rollover: null == rollover ? _self.rollover : rollover // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$BudgetWindow implements DiagnosticableTreeMixin {

 DateTime get start;/// Exclusive: the first instant that is no longer in the window.
 DateTime get end; String get label;
/// Create a copy of BudgetWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetWindowCopyWith<BudgetWindow> get copyWith => _$BudgetWindowCopyWithImpl<BudgetWindow>(this as BudgetWindow, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BudgetWindow'))
    ..add(DiagnosticsProperty('start', start))..add(DiagnosticsProperty('end', end))..add(DiagnosticsProperty('label', label));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetWindow&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,start,end,label);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BudgetWindow(start: $start, end: $end, label: $label)';
}


}

/// @nodoc
abstract mixin class $BudgetWindowCopyWith<$Res>  {
  factory $BudgetWindowCopyWith(BudgetWindow value, $Res Function(BudgetWindow) _then) = _$BudgetWindowCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime end, String label
});




}
/// @nodoc
class _$BudgetWindowCopyWithImpl<$Res>
    implements $BudgetWindowCopyWith<$Res> {
  _$BudgetWindowCopyWithImpl(this._self, this._then);

  final BudgetWindow _self;
  final $Res Function(BudgetWindow) _then;

/// Create a copy of BudgetWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,Object? label = null,}) {
  return _then(BudgetWindow(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetWindow].
extension BudgetWindowPatterns on BudgetWindow {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetWindow() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetWindow value)  $default,){
final _that = this;
switch (_that) {
case _BudgetWindow():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetWindow value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetWindow() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime start,  DateTime end,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetWindow() when $default != null:
return $default(_that.start,_that.end,_that.label);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime start,  DateTime end,  String label)  $default,) {final _that = this;
switch (_that) {
case _BudgetWindow():
return $default(_that.start,_that.end,_that.label);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime start,  DateTime end,  String label)?  $default,) {final _that = this;
switch (_that) {
case _BudgetWindow() when $default != null:
return $default(_that.start,_that.end,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetWindow with DiagnosticableTreeMixin implements BudgetWindow {
  const _BudgetWindow({required this.start, required this.end, required this.label});
  

@override final  DateTime start;
/// Exclusive: the first instant that is no longer in the window.
@override final  DateTime end;
@override final  String label;

/// Create a copy of BudgetWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetWindowCopyWith<_BudgetWindow> get copyWith => __$BudgetWindowCopyWithImpl<_BudgetWindow>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BudgetWindow'))
    ..add(DiagnosticsProperty('start', start))..add(DiagnosticsProperty('end', end))..add(DiagnosticsProperty('label', label));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetWindow&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,start,end,label);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BudgetWindow(start: $start, end: $end, label: $label)';
}


}

/// @nodoc
abstract mixin class _$BudgetWindowCopyWith<$Res> implements $BudgetWindowCopyWith<$Res> {
  factory _$BudgetWindowCopyWith(_BudgetWindow value, $Res Function(_BudgetWindow) _then) = __$BudgetWindowCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, DateTime end, String label
});




}
/// @nodoc
class __$BudgetWindowCopyWithImpl<$Res>
    implements _$BudgetWindowCopyWith<$Res> {
  __$BudgetWindowCopyWithImpl(this._self, this._then);

  final _BudgetWindow _self;
  final $Res Function(_BudgetWindow) _then;

/// Create a copy of BudgetWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,Object? label = null,}) {
  return _then(_BudgetWindow(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SubscriptionCadence implements DiagnosticableTreeMixin {

 String get frequency; int get interval; int? get dayOfMonth; int? get monthOfYear;
/// Create a copy of SubscriptionCadence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionCadenceCopyWith<SubscriptionCadence> get copyWith => _$SubscriptionCadenceCopyWithImpl<SubscriptionCadence>(this as SubscriptionCadence, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SubscriptionCadence'))
    ..add(DiagnosticsProperty('frequency', frequency))..add(DiagnosticsProperty('interval', interval))..add(DiagnosticsProperty('dayOfMonth', dayOfMonth))..add(DiagnosticsProperty('monthOfYear', monthOfYear));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionCadence&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.monthOfYear, monthOfYear) || other.monthOfYear == monthOfYear));
}


@override
int get hashCode => Object.hash(runtimeType,frequency,interval,dayOfMonth,monthOfYear);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SubscriptionCadence(frequency: $frequency, interval: $interval, dayOfMonth: $dayOfMonth, monthOfYear: $monthOfYear)';
}


}

/// @nodoc
abstract mixin class $SubscriptionCadenceCopyWith<$Res>  {
  factory $SubscriptionCadenceCopyWith(SubscriptionCadence value, $Res Function(SubscriptionCadence) _then) = _$SubscriptionCadenceCopyWithImpl;
@useResult
$Res call({
 String frequency, int interval, int? dayOfMonth, int? monthOfYear
});




}
/// @nodoc
class _$SubscriptionCadenceCopyWithImpl<$Res>
    implements $SubscriptionCadenceCopyWith<$Res> {
  _$SubscriptionCadenceCopyWithImpl(this._self, this._then);

  final SubscriptionCadence _self;
  final $Res Function(SubscriptionCadence) _then;

/// Create a copy of SubscriptionCadence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? frequency = null,Object? interval = null,Object? dayOfMonth = freezed,Object? monthOfYear = freezed,}) {
  return _then(SubscriptionCadence(
frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,monthOfYear: freezed == monthOfYear ? _self.monthOfYear : monthOfYear // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionCadence].
extension SubscriptionCadencePatterns on SubscriptionCadence {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionCadence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionCadence() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionCadence value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionCadence():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionCadence value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionCadence() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String frequency,  int interval,  int? dayOfMonth,  int? monthOfYear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionCadence() when $default != null:
return $default(_that.frequency,_that.interval,_that.dayOfMonth,_that.monthOfYear);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String frequency,  int interval,  int? dayOfMonth,  int? monthOfYear)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionCadence():
return $default(_that.frequency,_that.interval,_that.dayOfMonth,_that.monthOfYear);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String frequency,  int interval,  int? dayOfMonth,  int? monthOfYear)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionCadence() when $default != null:
return $default(_that.frequency,_that.interval,_that.dayOfMonth,_that.monthOfYear);case _:
  return null;

}
}

}

/// @nodoc


class _SubscriptionCadence with DiagnosticableTreeMixin implements SubscriptionCadence {
  const _SubscriptionCadence({this.frequency = 'MONTHLY', this.interval = 1, this.dayOfMonth, this.monthOfYear});
  

@override@JsonKey() final  String frequency;
@override@JsonKey() final  int interval;
@override final  int? dayOfMonth;
@override final  int? monthOfYear;

/// Create a copy of SubscriptionCadence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionCadenceCopyWith<_SubscriptionCadence> get copyWith => __$SubscriptionCadenceCopyWithImpl<_SubscriptionCadence>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SubscriptionCadence'))
    ..add(DiagnosticsProperty('frequency', frequency))..add(DiagnosticsProperty('interval', interval))..add(DiagnosticsProperty('dayOfMonth', dayOfMonth))..add(DiagnosticsProperty('monthOfYear', monthOfYear));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionCadence&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.monthOfYear, monthOfYear) || other.monthOfYear == monthOfYear));
}


@override
int get hashCode => Object.hash(runtimeType,frequency,interval,dayOfMonth,monthOfYear);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SubscriptionCadence(frequency: $frequency, interval: $interval, dayOfMonth: $dayOfMonth, monthOfYear: $monthOfYear)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionCadenceCopyWith<$Res> implements $SubscriptionCadenceCopyWith<$Res> {
  factory _$SubscriptionCadenceCopyWith(_SubscriptionCadence value, $Res Function(_SubscriptionCadence) _then) = __$SubscriptionCadenceCopyWithImpl;
@override @useResult
$Res call({
 String frequency, int interval, int? dayOfMonth, int? monthOfYear
});




}
/// @nodoc
class __$SubscriptionCadenceCopyWithImpl<$Res>
    implements _$SubscriptionCadenceCopyWith<$Res> {
  __$SubscriptionCadenceCopyWithImpl(this._self, this._then);

  final _SubscriptionCadence _self;
  final $Res Function(_SubscriptionCadence) _then;

/// Create a copy of SubscriptionCadence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? frequency = null,Object? interval = null,Object? dayOfMonth = freezed,Object? monthOfYear = freezed,}) {
  return _then(_SubscriptionCadence(
frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,dayOfMonth: freezed == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int?,monthOfYear: freezed == monthOfYear ? _self.monthOfYear : monthOfYear // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$Subscription implements DiagnosticableTreeMixin {

 String get id; String get name; int get amountMinor; String get currency; String get accountId; String get categoryId; String get icon; SubscriptionCadence get cadence; DateTime get startsOn; DateTime? get nextDueOn; DateTime? get lastPaidOn; SubscriptionStatus get status; bool get archived; RecurringKind get kind; DateTime? get endsOn; MoneyEventType get eventType;/// Occurrences always materialise as drafts you confirm. Auto-posting a
/// money record nobody looked at is how ledgers rot.
 bool get autoPost; List<String> get tagIds; String? get paymentMethodId; String get note; int get version;
/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionCopyWith<Subscription> get copyWith => _$SubscriptionCopyWithImpl<Subscription>(this as Subscription, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Subscription'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('accountId', accountId))..add(DiagnosticsProperty('categoryId', categoryId))..add(DiagnosticsProperty('icon', icon))..add(DiagnosticsProperty('cadence', cadence))..add(DiagnosticsProperty('startsOn', startsOn))..add(DiagnosticsProperty('nextDueOn', nextDueOn))..add(DiagnosticsProperty('lastPaidOn', lastPaidOn))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('archived', archived))..add(DiagnosticsProperty('kind', kind))..add(DiagnosticsProperty('endsOn', endsOn))..add(DiagnosticsProperty('eventType', eventType))..add(DiagnosticsProperty('autoPost', autoPost))..add(DiagnosticsProperty('tagIds', tagIds))..add(DiagnosticsProperty('paymentMethodId', paymentMethodId))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Subscription&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.startsOn, startsOn) || other.startsOn == startsOn)&&(identical(other.nextDueOn, nextDueOn) || other.nextDueOn == nextDueOn)&&(identical(other.lastPaidOn, lastPaidOn) || other.lastPaidOn == lastPaidOn)&&(identical(other.status, status) || other.status == status)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.endsOn, endsOn) || other.endsOn == endsOn)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.autoPost, autoPost) || other.autoPost == autoPost)&&const DeepCollectionEquality().equals(other.tagIds, tagIds)&&(identical(other.paymentMethodId, paymentMethodId) || other.paymentMethodId == paymentMethodId)&&(identical(other.note, note) || other.note == note)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,amountMinor,currency,accountId,categoryId,icon,cadence,startsOn,nextDueOn,lastPaidOn,status,archived,kind,endsOn,eventType,autoPost,const DeepCollectionEquality().hash(tagIds),paymentMethodId,note,version]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Subscription(id: $id, name: $name, amountMinor: $amountMinor, currency: $currency, accountId: $accountId, categoryId: $categoryId, icon: $icon, cadence: $cadence, startsOn: $startsOn, nextDueOn: $nextDueOn, lastPaidOn: $lastPaidOn, status: $status, archived: $archived, kind: $kind, endsOn: $endsOn, eventType: $eventType, autoPost: $autoPost, tagIds: $tagIds, paymentMethodId: $paymentMethodId, note: $note, version: $version)';
}


}

/// @nodoc
abstract mixin class $SubscriptionCopyWith<$Res>  {
  factory $SubscriptionCopyWith(Subscription value, $Res Function(Subscription) _then) = _$SubscriptionCopyWithImpl;
@useResult
$Res call({
 String id, String name, int amountMinor, String currency, String accountId, String categoryId, String icon, SubscriptionCadence cadence, DateTime startsOn, DateTime? nextDueOn, DateTime? lastPaidOn, SubscriptionStatus status, bool archived, RecurringKind kind, DateTime? endsOn, MoneyEventType eventType, bool autoPost, List<String> tagIds, String? paymentMethodId, String note, int version
});


$SubscriptionCadenceCopyWith<$Res> get cadence;

}
/// @nodoc
class _$SubscriptionCopyWithImpl<$Res>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._self, this._then);

  final Subscription _self;
  final $Res Function(Subscription) _then;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? amountMinor = null,Object? currency = null,Object? accountId = null,Object? categoryId = null,Object? icon = null,Object? cadence = null,Object? startsOn = null,Object? nextDueOn = freezed,Object? lastPaidOn = freezed,Object? status = null,Object? archived = null,Object? kind = null,Object? endsOn = freezed,Object? eventType = null,Object? autoPost = null,Object? tagIds = null,Object? paymentMethodId = freezed,Object? note = null,Object? version = null,}) {
  return _then(Subscription(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as SubscriptionCadence,startsOn: null == startsOn ? _self.startsOn : startsOn // ignore: cast_nullable_to_non_nullable
as DateTime,nextDueOn: freezed == nextDueOn ? _self.nextDueOn : nextDueOn // ignore: cast_nullable_to_non_nullable
as DateTime?,lastPaidOn: freezed == lastPaidOn ? _self.lastPaidOn : lastPaidOn // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RecurringKind,endsOn: freezed == endsOn ? _self.endsOn : endsOn // ignore: cast_nullable_to_non_nullable
as DateTime?,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as MoneyEventType,autoPost: null == autoPost ? _self.autoPost : autoPost // ignore: cast_nullable_to_non_nullable
as bool,tagIds: null == tagIds ? _self.tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,paymentMethodId: freezed == paymentMethodId ? _self.paymentMethodId : paymentMethodId // ignore: cast_nullable_to_non_nullable
as String?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionCadenceCopyWith<$Res> get cadence {
  
  return $SubscriptionCadenceCopyWith<$Res>(_self.cadence, (value) {
    return _then(_self.copyWith(cadence: value));
  });
}
}


/// Adds pattern-matching-related methods to [Subscription].
extension SubscriptionPatterns on Subscription {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Subscription value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Subscription value)  $default,){
final _that = this;
switch (_that) {
case _Subscription():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Subscription value)?  $default,){
final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int amountMinor,  String currency,  String accountId,  String categoryId,  String icon,  SubscriptionCadence cadence,  DateTime startsOn,  DateTime? nextDueOn,  DateTime? lastPaidOn,  SubscriptionStatus status,  bool archived,  RecurringKind kind,  DateTime? endsOn,  MoneyEventType eventType,  bool autoPost,  List<String> tagIds,  String? paymentMethodId,  String note,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that.id,_that.name,_that.amountMinor,_that.currency,_that.accountId,_that.categoryId,_that.icon,_that.cadence,_that.startsOn,_that.nextDueOn,_that.lastPaidOn,_that.status,_that.archived,_that.kind,_that.endsOn,_that.eventType,_that.autoPost,_that.tagIds,_that.paymentMethodId,_that.note,_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int amountMinor,  String currency,  String accountId,  String categoryId,  String icon,  SubscriptionCadence cadence,  DateTime startsOn,  DateTime? nextDueOn,  DateTime? lastPaidOn,  SubscriptionStatus status,  bool archived,  RecurringKind kind,  DateTime? endsOn,  MoneyEventType eventType,  bool autoPost,  List<String> tagIds,  String? paymentMethodId,  String note,  int version)  $default,) {final _that = this;
switch (_that) {
case _Subscription():
return $default(_that.id,_that.name,_that.amountMinor,_that.currency,_that.accountId,_that.categoryId,_that.icon,_that.cadence,_that.startsOn,_that.nextDueOn,_that.lastPaidOn,_that.status,_that.archived,_that.kind,_that.endsOn,_that.eventType,_that.autoPost,_that.tagIds,_that.paymentMethodId,_that.note,_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int amountMinor,  String currency,  String accountId,  String categoryId,  String icon,  SubscriptionCadence cadence,  DateTime startsOn,  DateTime? nextDueOn,  DateTime? lastPaidOn,  SubscriptionStatus status,  bool archived,  RecurringKind kind,  DateTime? endsOn,  MoneyEventType eventType,  bool autoPost,  List<String> tagIds,  String? paymentMethodId,  String note,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that.id,_that.name,_that.amountMinor,_that.currency,_that.accountId,_that.categoryId,_that.icon,_that.cadence,_that.startsOn,_that.nextDueOn,_that.lastPaidOn,_that.status,_that.archived,_that.kind,_that.endsOn,_that.eventType,_that.autoPost,_that.tagIds,_that.paymentMethodId,_that.note,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _Subscription with DiagnosticableTreeMixin implements Subscription {
  const _Subscription({required this.id, required this.name, required this.amountMinor, required this.currency, required this.accountId, required this.categoryId, required this.icon, required this.cadence, required this.startsOn, this.nextDueOn, this.lastPaidOn, this.status = SubscriptionStatus.active, this.archived = false, this.kind = RecurringKind.subscription, this.endsOn, this.eventType = MoneyEventType.expense, this.autoPost = false,  List<String> tagIds = const <String>[], this.paymentMethodId, this.note = '', this.version = 1}): _tagIds = tagIds;
  

@override final  String id;
@override final  String name;
@override final  int amountMinor;
@override final  String currency;
@override final  String accountId;
@override final  String categoryId;
@override final  String icon;
@override final  SubscriptionCadence cadence;
@override final  DateTime startsOn;
@override final  DateTime? nextDueOn;
@override final  DateTime? lastPaidOn;
@override@JsonKey() final  SubscriptionStatus status;
@override@JsonKey() final  bool archived;
@override@JsonKey() final  RecurringKind kind;
@override final  DateTime? endsOn;
@override@JsonKey() final  MoneyEventType eventType;
/// Occurrences always materialise as drafts you confirm. Auto-posting a
/// money record nobody looked at is how ledgers rot.
@override@JsonKey() final  bool autoPost;
 final  List<String> _tagIds;
@override@JsonKey() List<String> get tagIds {
  if (_tagIds is EqualUnmodifiableListView) return _tagIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tagIds);
}

@override final  String? paymentMethodId;
@override@JsonKey() final  String note;
@override@JsonKey() final  int version;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionCopyWith<_Subscription> get copyWith => __$SubscriptionCopyWithImpl<_Subscription>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Subscription'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('accountId', accountId))..add(DiagnosticsProperty('categoryId', categoryId))..add(DiagnosticsProperty('icon', icon))..add(DiagnosticsProperty('cadence', cadence))..add(DiagnosticsProperty('startsOn', startsOn))..add(DiagnosticsProperty('nextDueOn', nextDueOn))..add(DiagnosticsProperty('lastPaidOn', lastPaidOn))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('archived', archived))..add(DiagnosticsProperty('kind', kind))..add(DiagnosticsProperty('endsOn', endsOn))..add(DiagnosticsProperty('eventType', eventType))..add(DiagnosticsProperty('autoPost', autoPost))..add(DiagnosticsProperty('tagIds', tagIds))..add(DiagnosticsProperty('paymentMethodId', paymentMethodId))..add(DiagnosticsProperty('note', note))..add(DiagnosticsProperty('version', version));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Subscription&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.startsOn, startsOn) || other.startsOn == startsOn)&&(identical(other.nextDueOn, nextDueOn) || other.nextDueOn == nextDueOn)&&(identical(other.lastPaidOn, lastPaidOn) || other.lastPaidOn == lastPaidOn)&&(identical(other.status, status) || other.status == status)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.endsOn, endsOn) || other.endsOn == endsOn)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.autoPost, autoPost) || other.autoPost == autoPost)&&const DeepCollectionEquality().equals(other._tagIds, _tagIds)&&(identical(other.paymentMethodId, paymentMethodId) || other.paymentMethodId == paymentMethodId)&&(identical(other.note, note) || other.note == note)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,amountMinor,currency,accountId,categoryId,icon,cadence,startsOn,nextDueOn,lastPaidOn,status,archived,kind,endsOn,eventType,autoPost,const DeepCollectionEquality().hash(_tagIds),paymentMethodId,note,version]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Subscription(id: $id, name: $name, amountMinor: $amountMinor, currency: $currency, accountId: $accountId, categoryId: $categoryId, icon: $icon, cadence: $cadence, startsOn: $startsOn, nextDueOn: $nextDueOn, lastPaidOn: $lastPaidOn, status: $status, archived: $archived, kind: $kind, endsOn: $endsOn, eventType: $eventType, autoPost: $autoPost, tagIds: $tagIds, paymentMethodId: $paymentMethodId, note: $note, version: $version)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionCopyWith<$Res> implements $SubscriptionCopyWith<$Res> {
  factory _$SubscriptionCopyWith(_Subscription value, $Res Function(_Subscription) _then) = __$SubscriptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int amountMinor, String currency, String accountId, String categoryId, String icon, SubscriptionCadence cadence, DateTime startsOn, DateTime? nextDueOn, DateTime? lastPaidOn, SubscriptionStatus status, bool archived, RecurringKind kind, DateTime? endsOn, MoneyEventType eventType, bool autoPost, List<String> tagIds, String? paymentMethodId, String note, int version
});


@override $SubscriptionCadenceCopyWith<$Res> get cadence;

}
/// @nodoc
class __$SubscriptionCopyWithImpl<$Res>
    implements _$SubscriptionCopyWith<$Res> {
  __$SubscriptionCopyWithImpl(this._self, this._then);

  final _Subscription _self;
  final $Res Function(_Subscription) _then;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? amountMinor = null,Object? currency = null,Object? accountId = null,Object? categoryId = null,Object? icon = null,Object? cadence = null,Object? startsOn = null,Object? nextDueOn = freezed,Object? lastPaidOn = freezed,Object? status = null,Object? archived = null,Object? kind = null,Object? endsOn = freezed,Object? eventType = null,Object? autoPost = null,Object? tagIds = null,Object? paymentMethodId = freezed,Object? note = null,Object? version = null,}) {
  return _then(_Subscription(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as SubscriptionCadence,startsOn: null == startsOn ? _self.startsOn : startsOn // ignore: cast_nullable_to_non_nullable
as DateTime,nextDueOn: freezed == nextDueOn ? _self.nextDueOn : nextDueOn // ignore: cast_nullable_to_non_nullable
as DateTime?,lastPaidOn: freezed == lastPaidOn ? _self.lastPaidOn : lastPaidOn // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RecurringKind,endsOn: freezed == endsOn ? _self.endsOn : endsOn // ignore: cast_nullable_to_non_nullable
as DateTime?,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as MoneyEventType,autoPost: null == autoPost ? _self.autoPost : autoPost // ignore: cast_nullable_to_non_nullable
as bool,tagIds: null == tagIds ? _self._tagIds : tagIds // ignore: cast_nullable_to_non_nullable
as List<String>,paymentMethodId: freezed == paymentMethodId ? _self.paymentMethodId : paymentMethodId // ignore: cast_nullable_to_non_nullable
as String?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionCadenceCopyWith<$Res> get cadence {
  
  return $SubscriptionCadenceCopyWith<$Res>(_self.cadence, (value) {
    return _then(_self.copyWith(cadence: value));
  });
}
}

/// @nodoc
mixin _$FxSettings implements DiagnosticableTreeMixin {

 FxRateMode get mode; Map<String, double> get manualRates; DateTime get lastUpdatedAt;/// Which rate source is in force. A stable identifier rather than a
/// display string, so stored data does not change with the reader's
/// language; the UI translates it at render.
 FxProvider get provider; List<FxRateChange> get history;
/// Create a copy of FxSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FxSettingsCopyWith<FxSettings> get copyWith => _$FxSettingsCopyWithImpl<FxSettings>(this as FxSettings, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FxSettings'))
    ..add(DiagnosticsProperty('mode', mode))..add(DiagnosticsProperty('manualRates', manualRates))..add(DiagnosticsProperty('lastUpdatedAt', lastUpdatedAt))..add(DiagnosticsProperty('provider', provider))..add(DiagnosticsProperty('history', history));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FxSettings&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.manualRates, manualRates)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.provider, provider) || other.provider == provider)&&const DeepCollectionEquality().equals(other.history, history));
}


@override
int get hashCode => Object.hash(runtimeType,mode,const DeepCollectionEquality().hash(manualRates),lastUpdatedAt,provider,const DeepCollectionEquality().hash(history));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FxSettings(mode: $mode, manualRates: $manualRates, lastUpdatedAt: $lastUpdatedAt, provider: $provider, history: $history)';
}


}

/// @nodoc
abstract mixin class $FxSettingsCopyWith<$Res>  {
  factory $FxSettingsCopyWith(FxSettings value, $Res Function(FxSettings) _then) = _$FxSettingsCopyWithImpl;
@useResult
$Res call({
 FxRateMode mode, Map<String, double> manualRates, DateTime lastUpdatedAt, FxProvider provider, List<FxRateChange> history
});




}
/// @nodoc
class _$FxSettingsCopyWithImpl<$Res>
    implements $FxSettingsCopyWith<$Res> {
  _$FxSettingsCopyWithImpl(this._self, this._then);

  final FxSettings _self;
  final $Res Function(FxSettings) _then;

/// Create a copy of FxSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? manualRates = null,Object? lastUpdatedAt = null,Object? provider = null,Object? history = null,}) {
  return _then(FxSettings(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as FxRateMode,manualRates: null == manualRates ? _self.manualRates : manualRates // ignore: cast_nullable_to_non_nullable
as Map<String, double>,lastUpdatedAt: null == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as FxProvider,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<FxRateChange>,
  ));
}

}


/// Adds pattern-matching-related methods to [FxSettings].
extension FxSettingsPatterns on FxSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FxSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FxSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FxSettings value)  $default,){
final _that = this;
switch (_that) {
case _FxSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FxSettings value)?  $default,){
final _that = this;
switch (_that) {
case _FxSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FxRateMode mode,  Map<String, double> manualRates,  DateTime lastUpdatedAt,  FxProvider provider,  List<FxRateChange> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FxSettings() when $default != null:
return $default(_that.mode,_that.manualRates,_that.lastUpdatedAt,_that.provider,_that.history);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FxRateMode mode,  Map<String, double> manualRates,  DateTime lastUpdatedAt,  FxProvider provider,  List<FxRateChange> history)  $default,) {final _that = this;
switch (_that) {
case _FxSettings():
return $default(_that.mode,_that.manualRates,_that.lastUpdatedAt,_that.provider,_that.history);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FxRateMode mode,  Map<String, double> manualRates,  DateTime lastUpdatedAt,  FxProvider provider,  List<FxRateChange> history)?  $default,) {final _that = this;
switch (_that) {
case _FxSettings() when $default != null:
return $default(_that.mode,_that.manualRates,_that.lastUpdatedAt,_that.provider,_that.history);case _:
  return null;

}
}

}

/// @nodoc


class _FxSettings with DiagnosticableTreeMixin implements FxSettings {
  const _FxSettings({this.mode = FxRateMode.automatic,  Map<String, double> manualRates = const <String, double>{}, required this.lastUpdatedAt, this.provider = FxProvider.prototypeSnapshot,  List<FxRateChange> history = const <FxRateChange>[]}): _manualRates = manualRates,_history = history;
  

@override@JsonKey() final  FxRateMode mode;
 final  Map<String, double> _manualRates;
@override@JsonKey() Map<String, double> get manualRates {
  if (_manualRates is EqualUnmodifiableMapView) return _manualRates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_manualRates);
}

@override final  DateTime lastUpdatedAt;
/// Which rate source is in force. A stable identifier rather than a
/// display string, so stored data does not change with the reader's
/// language; the UI translates it at render.
@override@JsonKey() final  FxProvider provider;
 final  List<FxRateChange> _history;
@override@JsonKey() List<FxRateChange> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of FxSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FxSettingsCopyWith<_FxSettings> get copyWith => __$FxSettingsCopyWithImpl<_FxSettings>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FxSettings'))
    ..add(DiagnosticsProperty('mode', mode))..add(DiagnosticsProperty('manualRates', manualRates))..add(DiagnosticsProperty('lastUpdatedAt', lastUpdatedAt))..add(DiagnosticsProperty('provider', provider))..add(DiagnosticsProperty('history', history));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FxSettings&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other._manualRates, _manualRates)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.provider, provider) || other.provider == provider)&&const DeepCollectionEquality().equals(other._history, _history));
}


@override
int get hashCode => Object.hash(runtimeType,mode,const DeepCollectionEquality().hash(_manualRates),lastUpdatedAt,provider,const DeepCollectionEquality().hash(_history));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FxSettings(mode: $mode, manualRates: $manualRates, lastUpdatedAt: $lastUpdatedAt, provider: $provider, history: $history)';
}


}

/// @nodoc
abstract mixin class _$FxSettingsCopyWith<$Res> implements $FxSettingsCopyWith<$Res> {
  factory _$FxSettingsCopyWith(_FxSettings value, $Res Function(_FxSettings) _then) = __$FxSettingsCopyWithImpl;
@override @useResult
$Res call({
 FxRateMode mode, Map<String, double> manualRates, DateTime lastUpdatedAt, FxProvider provider, List<FxRateChange> history
});




}
/// @nodoc
class __$FxSettingsCopyWithImpl<$Res>
    implements _$FxSettingsCopyWith<$Res> {
  __$FxSettingsCopyWithImpl(this._self, this._then);

  final _FxSettings _self;
  final $Res Function(_FxSettings) _then;

/// Create a copy of FxSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? manualRates = null,Object? lastUpdatedAt = null,Object? provider = null,Object? history = null,}) {
  return _then(_FxSettings(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as FxRateMode,manualRates: null == manualRates ? _self._manualRates : manualRates // ignore: cast_nullable_to_non_nullable
as Map<String, double>,lastUpdatedAt: null == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as FxProvider,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<FxRateChange>,
  ));
}


}

/// @nodoc
mixin _$FxRateChange implements DiagnosticableTreeMixin {

 String get pair; double get rate; DateTime get at; FxRateMode get mode; FxProvider get source; double? get previousRate;
/// Create a copy of FxRateChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FxRateChangeCopyWith<FxRateChange> get copyWith => _$FxRateChangeCopyWithImpl<FxRateChange>(this as FxRateChange, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FxRateChange'))
    ..add(DiagnosticsProperty('pair', pair))..add(DiagnosticsProperty('rate', rate))..add(DiagnosticsProperty('at', at))..add(DiagnosticsProperty('mode', mode))..add(DiagnosticsProperty('source', source))..add(DiagnosticsProperty('previousRate', previousRate));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FxRateChange&&(identical(other.pair, pair) || other.pair == pair)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.at, at) || other.at == at)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.source, source) || other.source == source)&&(identical(other.previousRate, previousRate) || other.previousRate == previousRate));
}


@override
int get hashCode => Object.hash(runtimeType,pair,rate,at,mode,source,previousRate);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FxRateChange(pair: $pair, rate: $rate, at: $at, mode: $mode, source: $source, previousRate: $previousRate)';
}


}

/// @nodoc
abstract mixin class $FxRateChangeCopyWith<$Res>  {
  factory $FxRateChangeCopyWith(FxRateChange value, $Res Function(FxRateChange) _then) = _$FxRateChangeCopyWithImpl;
@useResult
$Res call({
 String pair, double rate, DateTime at, FxRateMode mode, FxProvider source, double? previousRate
});




}
/// @nodoc
class _$FxRateChangeCopyWithImpl<$Res>
    implements $FxRateChangeCopyWith<$Res> {
  _$FxRateChangeCopyWithImpl(this._self, this._then);

  final FxRateChange _self;
  final $Res Function(FxRateChange) _then;

/// Create a copy of FxRateChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pair = null,Object? rate = null,Object? at = null,Object? mode = null,Object? source = null,Object? previousRate = freezed,}) {
  return _then(FxRateChange(
pair: null == pair ? _self.pair : pair // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as FxRateMode,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as FxProvider,previousRate: freezed == previousRate ? _self.previousRate : previousRate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [FxRateChange].
extension FxRateChangePatterns on FxRateChange {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FxRateChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FxRateChange() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FxRateChange value)  $default,){
final _that = this;
switch (_that) {
case _FxRateChange():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FxRateChange value)?  $default,){
final _that = this;
switch (_that) {
case _FxRateChange() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pair,  double rate,  DateTime at,  FxRateMode mode,  FxProvider source,  double? previousRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FxRateChange() when $default != null:
return $default(_that.pair,_that.rate,_that.at,_that.mode,_that.source,_that.previousRate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pair,  double rate,  DateTime at,  FxRateMode mode,  FxProvider source,  double? previousRate)  $default,) {final _that = this;
switch (_that) {
case _FxRateChange():
return $default(_that.pair,_that.rate,_that.at,_that.mode,_that.source,_that.previousRate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pair,  double rate,  DateTime at,  FxRateMode mode,  FxProvider source,  double? previousRate)?  $default,) {final _that = this;
switch (_that) {
case _FxRateChange() when $default != null:
return $default(_that.pair,_that.rate,_that.at,_that.mode,_that.source,_that.previousRate);case _:
  return null;

}
}

}

/// @nodoc


class _FxRateChange with DiagnosticableTreeMixin implements FxRateChange {
  const _FxRateChange({required this.pair, required this.rate, required this.at, required this.mode, required this.source, this.previousRate});
  

@override final  String pair;
@override final  double rate;
@override final  DateTime at;
@override final  FxRateMode mode;
@override final  FxProvider source;
@override final  double? previousRate;

/// Create a copy of FxRateChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FxRateChangeCopyWith<_FxRateChange> get copyWith => __$FxRateChangeCopyWithImpl<_FxRateChange>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FxRateChange'))
    ..add(DiagnosticsProperty('pair', pair))..add(DiagnosticsProperty('rate', rate))..add(DiagnosticsProperty('at', at))..add(DiagnosticsProperty('mode', mode))..add(DiagnosticsProperty('source', source))..add(DiagnosticsProperty('previousRate', previousRate));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FxRateChange&&(identical(other.pair, pair) || other.pair == pair)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.at, at) || other.at == at)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.source, source) || other.source == source)&&(identical(other.previousRate, previousRate) || other.previousRate == previousRate));
}


@override
int get hashCode => Object.hash(runtimeType,pair,rate,at,mode,source,previousRate);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FxRateChange(pair: $pair, rate: $rate, at: $at, mode: $mode, source: $source, previousRate: $previousRate)';
}


}

/// @nodoc
abstract mixin class _$FxRateChangeCopyWith<$Res> implements $FxRateChangeCopyWith<$Res> {
  factory _$FxRateChangeCopyWith(_FxRateChange value, $Res Function(_FxRateChange) _then) = __$FxRateChangeCopyWithImpl;
@override @useResult
$Res call({
 String pair, double rate, DateTime at, FxRateMode mode, FxProvider source, double? previousRate
});




}
/// @nodoc
class __$FxRateChangeCopyWithImpl<$Res>
    implements _$FxRateChangeCopyWith<$Res> {
  __$FxRateChangeCopyWithImpl(this._self, this._then);

  final _FxRateChange _self;
  final $Res Function(_FxRateChange) _then;

/// Create a copy of FxRateChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pair = null,Object? rate = null,Object? at = null,Object? mode = null,Object? source = null,Object? previousRate = freezed,}) {
  return _then(_FxRateChange(
pair: null == pair ? _self.pair : pair // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as FxRateMode,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as FxProvider,previousRate: freezed == previousRate ? _self.previousRate : previousRate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$FxQuote implements DiagnosticableTreeMixin {

 String get fromCurrency; String get toCurrency; double get rate; FxRateMode get mode; DateTime get updatedAt; FxProvider get source;
/// Create a copy of FxQuote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FxQuoteCopyWith<FxQuote> get copyWith => _$FxQuoteCopyWithImpl<FxQuote>(this as FxQuote, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FxQuote'))
    ..add(DiagnosticsProperty('fromCurrency', fromCurrency))..add(DiagnosticsProperty('toCurrency', toCurrency))..add(DiagnosticsProperty('rate', rate))..add(DiagnosticsProperty('mode', mode))..add(DiagnosticsProperty('updatedAt', updatedAt))..add(DiagnosticsProperty('source', source));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FxQuote&&(identical(other.fromCurrency, fromCurrency) || other.fromCurrency == fromCurrency)&&(identical(other.toCurrency, toCurrency) || other.toCurrency == toCurrency)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,fromCurrency,toCurrency,rate,mode,updatedAt,source);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FxQuote(fromCurrency: $fromCurrency, toCurrency: $toCurrency, rate: $rate, mode: $mode, updatedAt: $updatedAt, source: $source)';
}


}

/// @nodoc
abstract mixin class $FxQuoteCopyWith<$Res>  {
  factory $FxQuoteCopyWith(FxQuote value, $Res Function(FxQuote) _then) = _$FxQuoteCopyWithImpl;
@useResult
$Res call({
 String fromCurrency, String toCurrency, double rate, FxRateMode mode, DateTime updatedAt, FxProvider source
});




}
/// @nodoc
class _$FxQuoteCopyWithImpl<$Res>
    implements $FxQuoteCopyWith<$Res> {
  _$FxQuoteCopyWithImpl(this._self, this._then);

  final FxQuote _self;
  final $Res Function(FxQuote) _then;

/// Create a copy of FxQuote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromCurrency = null,Object? toCurrency = null,Object? rate = null,Object? mode = null,Object? updatedAt = null,Object? source = null,}) {
  return _then(FxQuote(
fromCurrency: null == fromCurrency ? _self.fromCurrency : fromCurrency // ignore: cast_nullable_to_non_nullable
as String,toCurrency: null == toCurrency ? _self.toCurrency : toCurrency // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as FxRateMode,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as FxProvider,
  ));
}

}


/// Adds pattern-matching-related methods to [FxQuote].
extension FxQuotePatterns on FxQuote {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FxQuote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FxQuote() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FxQuote value)  $default,){
final _that = this;
switch (_that) {
case _FxQuote():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FxQuote value)?  $default,){
final _that = this;
switch (_that) {
case _FxQuote() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fromCurrency,  String toCurrency,  double rate,  FxRateMode mode,  DateTime updatedAt,  FxProvider source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FxQuote() when $default != null:
return $default(_that.fromCurrency,_that.toCurrency,_that.rate,_that.mode,_that.updatedAt,_that.source);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fromCurrency,  String toCurrency,  double rate,  FxRateMode mode,  DateTime updatedAt,  FxProvider source)  $default,) {final _that = this;
switch (_that) {
case _FxQuote():
return $default(_that.fromCurrency,_that.toCurrency,_that.rate,_that.mode,_that.updatedAt,_that.source);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fromCurrency,  String toCurrency,  double rate,  FxRateMode mode,  DateTime updatedAt,  FxProvider source)?  $default,) {final _that = this;
switch (_that) {
case _FxQuote() when $default != null:
return $default(_that.fromCurrency,_that.toCurrency,_that.rate,_that.mode,_that.updatedAt,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _FxQuote with DiagnosticableTreeMixin implements FxQuote {
  const _FxQuote({required this.fromCurrency, required this.toCurrency, required this.rate, required this.mode, required this.updatedAt, required this.source});
  

@override final  String fromCurrency;
@override final  String toCurrency;
@override final  double rate;
@override final  FxRateMode mode;
@override final  DateTime updatedAt;
@override final  FxProvider source;

/// Create a copy of FxQuote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FxQuoteCopyWith<_FxQuote> get copyWith => __$FxQuoteCopyWithImpl<_FxQuote>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FxQuote'))
    ..add(DiagnosticsProperty('fromCurrency', fromCurrency))..add(DiagnosticsProperty('toCurrency', toCurrency))..add(DiagnosticsProperty('rate', rate))..add(DiagnosticsProperty('mode', mode))..add(DiagnosticsProperty('updatedAt', updatedAt))..add(DiagnosticsProperty('source', source));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FxQuote&&(identical(other.fromCurrency, fromCurrency) || other.fromCurrency == fromCurrency)&&(identical(other.toCurrency, toCurrency) || other.toCurrency == toCurrency)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,fromCurrency,toCurrency,rate,mode,updatedAt,source);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FxQuote(fromCurrency: $fromCurrency, toCurrency: $toCurrency, rate: $rate, mode: $mode, updatedAt: $updatedAt, source: $source)';
}


}

/// @nodoc
abstract mixin class _$FxQuoteCopyWith<$Res> implements $FxQuoteCopyWith<$Res> {
  factory _$FxQuoteCopyWith(_FxQuote value, $Res Function(_FxQuote) _then) = __$FxQuoteCopyWithImpl;
@override @useResult
$Res call({
 String fromCurrency, String toCurrency, double rate, FxRateMode mode, DateTime updatedAt, FxProvider source
});




}
/// @nodoc
class __$FxQuoteCopyWithImpl<$Res>
    implements _$FxQuoteCopyWith<$Res> {
  __$FxQuoteCopyWithImpl(this._self, this._then);

  final _FxQuote _self;
  final $Res Function(_FxQuote) _then;

/// Create a copy of FxQuote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromCurrency = null,Object? toCurrency = null,Object? rate = null,Object? mode = null,Object? updatedAt = null,Object? source = null,}) {
  return _then(_FxQuote(
fromCurrency: null == fromCurrency ? _self.fromCurrency : fromCurrency // ignore: cast_nullable_to_non_nullable
as String,toCurrency: null == toCurrency ? _self.toCurrency : toCurrency // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as FxRateMode,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as FxProvider,
  ));
}


}

/// @nodoc
mixin _$SpaceInvitation implements DiagnosticableTreeMixin {

 String get id; String get spaceId; String get name; String get email; DateTime get invitedAt; InvitationStatus get status; DateTime? get respondedAt; String? get userId;/// Invites expire so a forwarded link does not stay live forever.
 DateTime get expiresAt; int get expiryDays; SpaceRole get role; String get invitedByUserId; int get resendCount;
/// Create a copy of SpaceInvitation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceInvitationCopyWith<SpaceInvitation> get copyWith => _$SpaceInvitationCopyWithImpl<SpaceInvitation>(this as SpaceInvitation, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpaceInvitation'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('email', email))..add(DiagnosticsProperty('invitedAt', invitedAt))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('respondedAt', respondedAt))..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('expiresAt', expiresAt))..add(DiagnosticsProperty('expiryDays', expiryDays))..add(DiagnosticsProperty('role', role))..add(DiagnosticsProperty('invitedByUserId', invitedByUserId))..add(DiagnosticsProperty('resendCount', resendCount));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceInvitation&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.invitedAt, invitedAt) || other.invitedAt == invitedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.expiryDays, expiryDays) || other.expiryDays == expiryDays)&&(identical(other.role, role) || other.role == role)&&(identical(other.invitedByUserId, invitedByUserId) || other.invitedByUserId == invitedByUserId)&&(identical(other.resendCount, resendCount) || other.resendCount == resendCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,name,email,invitedAt,status,respondedAt,userId,expiresAt,expiryDays,role,invitedByUserId,resendCount);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpaceInvitation(id: $id, spaceId: $spaceId, name: $name, email: $email, invitedAt: $invitedAt, status: $status, respondedAt: $respondedAt, userId: $userId, expiresAt: $expiresAt, expiryDays: $expiryDays, role: $role, invitedByUserId: $invitedByUserId, resendCount: $resendCount)';
}


}

/// @nodoc
abstract mixin class $SpaceInvitationCopyWith<$Res>  {
  factory $SpaceInvitationCopyWith(SpaceInvitation value, $Res Function(SpaceInvitation) _then) = _$SpaceInvitationCopyWithImpl;
@useResult
$Res call({
 String id, String spaceId, String name, String email, DateTime invitedAt, InvitationStatus status, DateTime? respondedAt, String? userId, DateTime expiresAt, int expiryDays, SpaceRole role, String invitedByUserId, int resendCount
});




}
/// @nodoc
class _$SpaceInvitationCopyWithImpl<$Res>
    implements $SpaceInvitationCopyWith<$Res> {
  _$SpaceInvitationCopyWithImpl(this._self, this._then);

  final SpaceInvitation _self;
  final $Res Function(SpaceInvitation) _then;

/// Create a copy of SpaceInvitation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = null,Object? name = null,Object? email = null,Object? invitedAt = null,Object? status = null,Object? respondedAt = freezed,Object? userId = freezed,Object? expiresAt = null,Object? expiryDays = null,Object? role = null,Object? invitedByUserId = null,Object? resendCount = null,}) {
  return _then(SpaceInvitation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,invitedAt: null == invitedAt ? _self.invitedAt : invitedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvitationStatus,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiryDays: null == expiryDays ? _self.expiryDays : expiryDays // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as SpaceRole,invitedByUserId: null == invitedByUserId ? _self.invitedByUserId : invitedByUserId // ignore: cast_nullable_to_non_nullable
as String,resendCount: null == resendCount ? _self.resendCount : resendCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceInvitation].
extension SpaceInvitationPatterns on SpaceInvitation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceInvitation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceInvitation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceInvitation value)  $default,){
final _that = this;
switch (_that) {
case _SpaceInvitation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceInvitation value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceInvitation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String spaceId,  String name,  String email,  DateTime invitedAt,  InvitationStatus status,  DateTime? respondedAt,  String? userId,  DateTime expiresAt,  int expiryDays,  SpaceRole role,  String invitedByUserId,  int resendCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceInvitation() when $default != null:
return $default(_that.id,_that.spaceId,_that.name,_that.email,_that.invitedAt,_that.status,_that.respondedAt,_that.userId,_that.expiresAt,_that.expiryDays,_that.role,_that.invitedByUserId,_that.resendCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String spaceId,  String name,  String email,  DateTime invitedAt,  InvitationStatus status,  DateTime? respondedAt,  String? userId,  DateTime expiresAt,  int expiryDays,  SpaceRole role,  String invitedByUserId,  int resendCount)  $default,) {final _that = this;
switch (_that) {
case _SpaceInvitation():
return $default(_that.id,_that.spaceId,_that.name,_that.email,_that.invitedAt,_that.status,_that.respondedAt,_that.userId,_that.expiresAt,_that.expiryDays,_that.role,_that.invitedByUserId,_that.resendCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String spaceId,  String name,  String email,  DateTime invitedAt,  InvitationStatus status,  DateTime? respondedAt,  String? userId,  DateTime expiresAt,  int expiryDays,  SpaceRole role,  String invitedByUserId,  int resendCount)?  $default,) {final _that = this;
switch (_that) {
case _SpaceInvitation() when $default != null:
return $default(_that.id,_that.spaceId,_that.name,_that.email,_that.invitedAt,_that.status,_that.respondedAt,_that.userId,_that.expiresAt,_that.expiryDays,_that.role,_that.invitedByUserId,_that.resendCount);case _:
  return null;

}
}

}

/// @nodoc


class _SpaceInvitation with DiagnosticableTreeMixin implements SpaceInvitation {
  const _SpaceInvitation({required this.id, required this.spaceId, required this.name, required this.email, required this.invitedAt, this.status = InvitationStatus.pending, this.respondedAt, this.userId, required this.expiresAt, this.expiryDays = 7, this.role = SpaceRole.member, this.invitedByUserId = '', this.resendCount = 0});
  

@override final  String id;
@override final  String spaceId;
@override final  String name;
@override final  String email;
@override final  DateTime invitedAt;
@override@JsonKey() final  InvitationStatus status;
@override final  DateTime? respondedAt;
@override final  String? userId;
/// Invites expire so a forwarded link does not stay live forever.
@override final  DateTime expiresAt;
@override@JsonKey() final  int expiryDays;
@override@JsonKey() final  SpaceRole role;
@override@JsonKey() final  String invitedByUserId;
@override@JsonKey() final  int resendCount;

/// Create a copy of SpaceInvitation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceInvitationCopyWith<_SpaceInvitation> get copyWith => __$SpaceInvitationCopyWithImpl<_SpaceInvitation>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpaceInvitation'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('email', email))..add(DiagnosticsProperty('invitedAt', invitedAt))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('respondedAt', respondedAt))..add(DiagnosticsProperty('userId', userId))..add(DiagnosticsProperty('expiresAt', expiresAt))..add(DiagnosticsProperty('expiryDays', expiryDays))..add(DiagnosticsProperty('role', role))..add(DiagnosticsProperty('invitedByUserId', invitedByUserId))..add(DiagnosticsProperty('resendCount', resendCount));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceInvitation&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.invitedAt, invitedAt) || other.invitedAt == invitedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.expiryDays, expiryDays) || other.expiryDays == expiryDays)&&(identical(other.role, role) || other.role == role)&&(identical(other.invitedByUserId, invitedByUserId) || other.invitedByUserId == invitedByUserId)&&(identical(other.resendCount, resendCount) || other.resendCount == resendCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,name,email,invitedAt,status,respondedAt,userId,expiresAt,expiryDays,role,invitedByUserId,resendCount);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpaceInvitation(id: $id, spaceId: $spaceId, name: $name, email: $email, invitedAt: $invitedAt, status: $status, respondedAt: $respondedAt, userId: $userId, expiresAt: $expiresAt, expiryDays: $expiryDays, role: $role, invitedByUserId: $invitedByUserId, resendCount: $resendCount)';
}


}

/// @nodoc
abstract mixin class _$SpaceInvitationCopyWith<$Res> implements $SpaceInvitationCopyWith<$Res> {
  factory _$SpaceInvitationCopyWith(_SpaceInvitation value, $Res Function(_SpaceInvitation) _then) = __$SpaceInvitationCopyWithImpl;
@override @useResult
$Res call({
 String id, String spaceId, String name, String email, DateTime invitedAt, InvitationStatus status, DateTime? respondedAt, String? userId, DateTime expiresAt, int expiryDays, SpaceRole role, String invitedByUserId, int resendCount
});




}
/// @nodoc
class __$SpaceInvitationCopyWithImpl<$Res>
    implements _$SpaceInvitationCopyWith<$Res> {
  __$SpaceInvitationCopyWithImpl(this._self, this._then);

  final _SpaceInvitation _self;
  final $Res Function(_SpaceInvitation) _then;

/// Create a copy of SpaceInvitation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = null,Object? name = null,Object? email = null,Object? invitedAt = null,Object? status = null,Object? respondedAt = freezed,Object? userId = freezed,Object? expiresAt = null,Object? expiryDays = null,Object? role = null,Object? invitedByUserId = null,Object? resendCount = null,}) {
  return _then(_SpaceInvitation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,invitedAt: null == invitedAt ? _self.invitedAt : invitedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvitationStatus,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiryDays: null == expiryDays ? _self.expiryDays : expiryDays // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as SpaceRole,invitedByUserId: null == invitedByUserId ? _self.invitedByUserId : invitedByUserId // ignore: cast_nullable_to_non_nullable
as String,resendCount: null == resendCount ? _self.resendCount : resendCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SpaceCycle implements DiagnosticableTreeMixin {

 String get id; String get spaceId; String get label; DateTime get startedAt; DateTime get endedAt; List<String> get expenseIds; List<String> get settlementIds; int get spentMinor; String get currency; int get budgetLimitMinor; Map<String, int> get memberPaidMinor; Map<String, int> get memberResponsibilityMinor; Map<String, int> get categoryTotalsMinor;
/// Create a copy of SpaceCycle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceCycleCopyWith<SpaceCycle> get copyWith => _$SpaceCycleCopyWithImpl<SpaceCycle>(this as SpaceCycle, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpaceCycle'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('label', label))..add(DiagnosticsProperty('startedAt', startedAt))..add(DiagnosticsProperty('endedAt', endedAt))..add(DiagnosticsProperty('expenseIds', expenseIds))..add(DiagnosticsProperty('settlementIds', settlementIds))..add(DiagnosticsProperty('spentMinor', spentMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('budgetLimitMinor', budgetLimitMinor))..add(DiagnosticsProperty('memberPaidMinor', memberPaidMinor))..add(DiagnosticsProperty('memberResponsibilityMinor', memberResponsibilityMinor))..add(DiagnosticsProperty('categoryTotalsMinor', categoryTotalsMinor));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceCycle&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.label, label) || other.label == label)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&const DeepCollectionEquality().equals(other.expenseIds, expenseIds)&&const DeepCollectionEquality().equals(other.settlementIds, settlementIds)&&(identical(other.spentMinor, spentMinor) || other.spentMinor == spentMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.budgetLimitMinor, budgetLimitMinor) || other.budgetLimitMinor == budgetLimitMinor)&&const DeepCollectionEquality().equals(other.memberPaidMinor, memberPaidMinor)&&const DeepCollectionEquality().equals(other.memberResponsibilityMinor, memberResponsibilityMinor)&&const DeepCollectionEquality().equals(other.categoryTotalsMinor, categoryTotalsMinor));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,label,startedAt,endedAt,const DeepCollectionEquality().hash(expenseIds),const DeepCollectionEquality().hash(settlementIds),spentMinor,currency,budgetLimitMinor,const DeepCollectionEquality().hash(memberPaidMinor),const DeepCollectionEquality().hash(memberResponsibilityMinor),const DeepCollectionEquality().hash(categoryTotalsMinor));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpaceCycle(id: $id, spaceId: $spaceId, label: $label, startedAt: $startedAt, endedAt: $endedAt, expenseIds: $expenseIds, settlementIds: $settlementIds, spentMinor: $spentMinor, currency: $currency, budgetLimitMinor: $budgetLimitMinor, memberPaidMinor: $memberPaidMinor, memberResponsibilityMinor: $memberResponsibilityMinor, categoryTotalsMinor: $categoryTotalsMinor)';
}


}

/// @nodoc
abstract mixin class $SpaceCycleCopyWith<$Res>  {
  factory $SpaceCycleCopyWith(SpaceCycle value, $Res Function(SpaceCycle) _then) = _$SpaceCycleCopyWithImpl;
@useResult
$Res call({
 String id, String spaceId, String label, DateTime startedAt, DateTime endedAt, List<String> expenseIds, List<String> settlementIds, int spentMinor, String currency, int budgetLimitMinor, Map<String, int> memberPaidMinor, Map<String, int> memberResponsibilityMinor, Map<String, int> categoryTotalsMinor
});




}
/// @nodoc
class _$SpaceCycleCopyWithImpl<$Res>
    implements $SpaceCycleCopyWith<$Res> {
  _$SpaceCycleCopyWithImpl(this._self, this._then);

  final SpaceCycle _self;
  final $Res Function(SpaceCycle) _then;

/// Create a copy of SpaceCycle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = null,Object? label = null,Object? startedAt = null,Object? endedAt = null,Object? expenseIds = null,Object? settlementIds = null,Object? spentMinor = null,Object? currency = null,Object? budgetLimitMinor = null,Object? memberPaidMinor = null,Object? memberResponsibilityMinor = null,Object? categoryTotalsMinor = null,}) {
  return _then(SpaceCycle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expenseIds: null == expenseIds ? _self.expenseIds : expenseIds // ignore: cast_nullable_to_non_nullable
as List<String>,settlementIds: null == settlementIds ? _self.settlementIds : settlementIds // ignore: cast_nullable_to_non_nullable
as List<String>,spentMinor: null == spentMinor ? _self.spentMinor : spentMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,budgetLimitMinor: null == budgetLimitMinor ? _self.budgetLimitMinor : budgetLimitMinor // ignore: cast_nullable_to_non_nullable
as int,memberPaidMinor: null == memberPaidMinor ? _self.memberPaidMinor : memberPaidMinor // ignore: cast_nullable_to_non_nullable
as Map<String, int>,memberResponsibilityMinor: null == memberResponsibilityMinor ? _self.memberResponsibilityMinor : memberResponsibilityMinor // ignore: cast_nullable_to_non_nullable
as Map<String, int>,categoryTotalsMinor: null == categoryTotalsMinor ? _self.categoryTotalsMinor : categoryTotalsMinor // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceCycle].
extension SpaceCyclePatterns on SpaceCycle {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceCycle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceCycle() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceCycle value)  $default,){
final _that = this;
switch (_that) {
case _SpaceCycle():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceCycle value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceCycle() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String spaceId,  String label,  DateTime startedAt,  DateTime endedAt,  List<String> expenseIds,  List<String> settlementIds,  int spentMinor,  String currency,  int budgetLimitMinor,  Map<String, int> memberPaidMinor,  Map<String, int> memberResponsibilityMinor,  Map<String, int> categoryTotalsMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceCycle() when $default != null:
return $default(_that.id,_that.spaceId,_that.label,_that.startedAt,_that.endedAt,_that.expenseIds,_that.settlementIds,_that.spentMinor,_that.currency,_that.budgetLimitMinor,_that.memberPaidMinor,_that.memberResponsibilityMinor,_that.categoryTotalsMinor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String spaceId,  String label,  DateTime startedAt,  DateTime endedAt,  List<String> expenseIds,  List<String> settlementIds,  int spentMinor,  String currency,  int budgetLimitMinor,  Map<String, int> memberPaidMinor,  Map<String, int> memberResponsibilityMinor,  Map<String, int> categoryTotalsMinor)  $default,) {final _that = this;
switch (_that) {
case _SpaceCycle():
return $default(_that.id,_that.spaceId,_that.label,_that.startedAt,_that.endedAt,_that.expenseIds,_that.settlementIds,_that.spentMinor,_that.currency,_that.budgetLimitMinor,_that.memberPaidMinor,_that.memberResponsibilityMinor,_that.categoryTotalsMinor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String spaceId,  String label,  DateTime startedAt,  DateTime endedAt,  List<String> expenseIds,  List<String> settlementIds,  int spentMinor,  String currency,  int budgetLimitMinor,  Map<String, int> memberPaidMinor,  Map<String, int> memberResponsibilityMinor,  Map<String, int> categoryTotalsMinor)?  $default,) {final _that = this;
switch (_that) {
case _SpaceCycle() when $default != null:
return $default(_that.id,_that.spaceId,_that.label,_that.startedAt,_that.endedAt,_that.expenseIds,_that.settlementIds,_that.spentMinor,_that.currency,_that.budgetLimitMinor,_that.memberPaidMinor,_that.memberResponsibilityMinor,_that.categoryTotalsMinor);case _:
  return null;

}
}

}

/// @nodoc


class _SpaceCycle with DiagnosticableTreeMixin implements SpaceCycle {
  const _SpaceCycle({required this.id, required this.spaceId, required this.label, required this.startedAt, required this.endedAt, required  List<String> expenseIds, required  List<String> settlementIds, required this.spentMinor, required this.currency, this.budgetLimitMinor = 0,  Map<String, int> memberPaidMinor = const <String, int>{},  Map<String, int> memberResponsibilityMinor = const <String, int>{},  Map<String, int> categoryTotalsMinor = const <String, int>{}}): _expenseIds = expenseIds,_settlementIds = settlementIds,_memberPaidMinor = memberPaidMinor,_memberResponsibilityMinor = memberResponsibilityMinor,_categoryTotalsMinor = categoryTotalsMinor;
  

@override final  String id;
@override final  String spaceId;
@override final  String label;
@override final  DateTime startedAt;
@override final  DateTime endedAt;
 final  List<String> _expenseIds;
@override List<String> get expenseIds {
  if (_expenseIds is EqualUnmodifiableListView) return _expenseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenseIds);
}

 final  List<String> _settlementIds;
@override List<String> get settlementIds {
  if (_settlementIds is EqualUnmodifiableListView) return _settlementIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_settlementIds);
}

@override final  int spentMinor;
@override final  String currency;
@override@JsonKey() final  int budgetLimitMinor;
 final  Map<String, int> _memberPaidMinor;
@override@JsonKey() Map<String, int> get memberPaidMinor {
  if (_memberPaidMinor is EqualUnmodifiableMapView) return _memberPaidMinor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_memberPaidMinor);
}

 final  Map<String, int> _memberResponsibilityMinor;
@override@JsonKey() Map<String, int> get memberResponsibilityMinor {
  if (_memberResponsibilityMinor is EqualUnmodifiableMapView) return _memberResponsibilityMinor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_memberResponsibilityMinor);
}

 final  Map<String, int> _categoryTotalsMinor;
@override@JsonKey() Map<String, int> get categoryTotalsMinor {
  if (_categoryTotalsMinor is EqualUnmodifiableMapView) return _categoryTotalsMinor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categoryTotalsMinor);
}


/// Create a copy of SpaceCycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceCycleCopyWith<_SpaceCycle> get copyWith => __$SpaceCycleCopyWithImpl<_SpaceCycle>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpaceCycle'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('label', label))..add(DiagnosticsProperty('startedAt', startedAt))..add(DiagnosticsProperty('endedAt', endedAt))..add(DiagnosticsProperty('expenseIds', expenseIds))..add(DiagnosticsProperty('settlementIds', settlementIds))..add(DiagnosticsProperty('spentMinor', spentMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('budgetLimitMinor', budgetLimitMinor))..add(DiagnosticsProperty('memberPaidMinor', memberPaidMinor))..add(DiagnosticsProperty('memberResponsibilityMinor', memberResponsibilityMinor))..add(DiagnosticsProperty('categoryTotalsMinor', categoryTotalsMinor));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceCycle&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.label, label) || other.label == label)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&const DeepCollectionEquality().equals(other._expenseIds, _expenseIds)&&const DeepCollectionEquality().equals(other._settlementIds, _settlementIds)&&(identical(other.spentMinor, spentMinor) || other.spentMinor == spentMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.budgetLimitMinor, budgetLimitMinor) || other.budgetLimitMinor == budgetLimitMinor)&&const DeepCollectionEquality().equals(other._memberPaidMinor, _memberPaidMinor)&&const DeepCollectionEquality().equals(other._memberResponsibilityMinor, _memberResponsibilityMinor)&&const DeepCollectionEquality().equals(other._categoryTotalsMinor, _categoryTotalsMinor));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,label,startedAt,endedAt,const DeepCollectionEquality().hash(_expenseIds),const DeepCollectionEquality().hash(_settlementIds),spentMinor,currency,budgetLimitMinor,const DeepCollectionEquality().hash(_memberPaidMinor),const DeepCollectionEquality().hash(_memberResponsibilityMinor),const DeepCollectionEquality().hash(_categoryTotalsMinor));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpaceCycle(id: $id, spaceId: $spaceId, label: $label, startedAt: $startedAt, endedAt: $endedAt, expenseIds: $expenseIds, settlementIds: $settlementIds, spentMinor: $spentMinor, currency: $currency, budgetLimitMinor: $budgetLimitMinor, memberPaidMinor: $memberPaidMinor, memberResponsibilityMinor: $memberResponsibilityMinor, categoryTotalsMinor: $categoryTotalsMinor)';
}


}

/// @nodoc
abstract mixin class _$SpaceCycleCopyWith<$Res> implements $SpaceCycleCopyWith<$Res> {
  factory _$SpaceCycleCopyWith(_SpaceCycle value, $Res Function(_SpaceCycle) _then) = __$SpaceCycleCopyWithImpl;
@override @useResult
$Res call({
 String id, String spaceId, String label, DateTime startedAt, DateTime endedAt, List<String> expenseIds, List<String> settlementIds, int spentMinor, String currency, int budgetLimitMinor, Map<String, int> memberPaidMinor, Map<String, int> memberResponsibilityMinor, Map<String, int> categoryTotalsMinor
});




}
/// @nodoc
class __$SpaceCycleCopyWithImpl<$Res>
    implements _$SpaceCycleCopyWith<$Res> {
  __$SpaceCycleCopyWithImpl(this._self, this._then);

  final _SpaceCycle _self;
  final $Res Function(_SpaceCycle) _then;

/// Create a copy of SpaceCycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = null,Object? label = null,Object? startedAt = null,Object? endedAt = null,Object? expenseIds = null,Object? settlementIds = null,Object? spentMinor = null,Object? currency = null,Object? budgetLimitMinor = null,Object? memberPaidMinor = null,Object? memberResponsibilityMinor = null,Object? categoryTotalsMinor = null,}) {
  return _then(_SpaceCycle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expenseIds: null == expenseIds ? _self._expenseIds : expenseIds // ignore: cast_nullable_to_non_nullable
as List<String>,settlementIds: null == settlementIds ? _self._settlementIds : settlementIds // ignore: cast_nullable_to_non_nullable
as List<String>,spentMinor: null == spentMinor ? _self.spentMinor : spentMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,budgetLimitMinor: null == budgetLimitMinor ? _self.budgetLimitMinor : budgetLimitMinor // ignore: cast_nullable_to_non_nullable
as int,memberPaidMinor: null == memberPaidMinor ? _self._memberPaidMinor : memberPaidMinor // ignore: cast_nullable_to_non_nullable
as Map<String, int>,memberResponsibilityMinor: null == memberResponsibilityMinor ? _self._memberResponsibilityMinor : memberResponsibilityMinor // ignore: cast_nullable_to_non_nullable
as Map<String, int>,categoryTotalsMinor: null == categoryTotalsMinor ? _self._categoryTotalsMinor : categoryTotalsMinor // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

/// @nodoc
mixin _$SpaceActivityEvent implements DiagnosticableTreeMixin {

 String get id; String get spaceId; String get actorUserId; DateTime get at; SpaceActivityType get type;/// Plain-language sentence for the friendly view.
 String get summary; ActivityOutcome get outcome; String? get entityId; String? get entityLabel;/// The permission that was checked, present on denied entries.
 String? get permission; String? get detail;
/// Create a copy of SpaceActivityEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceActivityEventCopyWith<SpaceActivityEvent> get copyWith => _$SpaceActivityEventCopyWithImpl<SpaceActivityEvent>(this as SpaceActivityEvent, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpaceActivityEvent'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('actorUserId', actorUserId))..add(DiagnosticsProperty('at', at))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('summary', summary))..add(DiagnosticsProperty('outcome', outcome))..add(DiagnosticsProperty('entityId', entityId))..add(DiagnosticsProperty('entityLabel', entityLabel))..add(DiagnosticsProperty('permission', permission))..add(DiagnosticsProperty('detail', detail));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceActivityEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.actorUserId, actorUserId) || other.actorUserId == actorUserId)&&(identical(other.at, at) || other.at == at)&&(identical(other.type, type) || other.type == type)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityLabel, entityLabel) || other.entityLabel == entityLabel)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,actorUserId,at,type,summary,outcome,entityId,entityLabel,permission,detail);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpaceActivityEvent(id: $id, spaceId: $spaceId, actorUserId: $actorUserId, at: $at, type: $type, summary: $summary, outcome: $outcome, entityId: $entityId, entityLabel: $entityLabel, permission: $permission, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $SpaceActivityEventCopyWith<$Res>  {
  factory $SpaceActivityEventCopyWith(SpaceActivityEvent value, $Res Function(SpaceActivityEvent) _then) = _$SpaceActivityEventCopyWithImpl;
@useResult
$Res call({
 String id, String spaceId, String actorUserId, DateTime at, SpaceActivityType type, String summary, ActivityOutcome outcome, String? entityId, String? entityLabel, String? permission, String? detail
});




}
/// @nodoc
class _$SpaceActivityEventCopyWithImpl<$Res>
    implements $SpaceActivityEventCopyWith<$Res> {
  _$SpaceActivityEventCopyWithImpl(this._self, this._then);

  final SpaceActivityEvent _self;
  final $Res Function(SpaceActivityEvent) _then;

/// Create a copy of SpaceActivityEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = null,Object? actorUserId = null,Object? at = null,Object? type = null,Object? summary = null,Object? outcome = null,Object? entityId = freezed,Object? entityLabel = freezed,Object? permission = freezed,Object? detail = freezed,}) {
  return _then(SpaceActivityEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,actorUserId: null == actorUserId ? _self.actorUserId : actorUserId // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SpaceActivityType,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as ActivityOutcome,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,entityLabel: freezed == entityLabel ? _self.entityLabel : entityLabel // ignore: cast_nullable_to_non_nullable
as String?,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceActivityEvent].
extension SpaceActivityEventPatterns on SpaceActivityEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceActivityEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceActivityEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceActivityEvent value)  $default,){
final _that = this;
switch (_that) {
case _SpaceActivityEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceActivityEvent value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceActivityEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String spaceId,  String actorUserId,  DateTime at,  SpaceActivityType type,  String summary,  ActivityOutcome outcome,  String? entityId,  String? entityLabel,  String? permission,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceActivityEvent() when $default != null:
return $default(_that.id,_that.spaceId,_that.actorUserId,_that.at,_that.type,_that.summary,_that.outcome,_that.entityId,_that.entityLabel,_that.permission,_that.detail);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String spaceId,  String actorUserId,  DateTime at,  SpaceActivityType type,  String summary,  ActivityOutcome outcome,  String? entityId,  String? entityLabel,  String? permission,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _SpaceActivityEvent():
return $default(_that.id,_that.spaceId,_that.actorUserId,_that.at,_that.type,_that.summary,_that.outcome,_that.entityId,_that.entityLabel,_that.permission,_that.detail);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String spaceId,  String actorUserId,  DateTime at,  SpaceActivityType type,  String summary,  ActivityOutcome outcome,  String? entityId,  String? entityLabel,  String? permission,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _SpaceActivityEvent() when $default != null:
return $default(_that.id,_that.spaceId,_that.actorUserId,_that.at,_that.type,_that.summary,_that.outcome,_that.entityId,_that.entityLabel,_that.permission,_that.detail);case _:
  return null;

}
}

}

/// @nodoc


class _SpaceActivityEvent with DiagnosticableTreeMixin implements SpaceActivityEvent {
  const _SpaceActivityEvent({required this.id, required this.spaceId, required this.actorUserId, required this.at, required this.type, required this.summary, this.outcome = ActivityOutcome.granted, this.entityId, this.entityLabel, this.permission, this.detail});
  

@override final  String id;
@override final  String spaceId;
@override final  String actorUserId;
@override final  DateTime at;
@override final  SpaceActivityType type;
/// Plain-language sentence for the friendly view.
@override final  String summary;
@override@JsonKey() final  ActivityOutcome outcome;
@override final  String? entityId;
@override final  String? entityLabel;
/// The permission that was checked, present on denied entries.
@override final  String? permission;
@override final  String? detail;

/// Create a copy of SpaceActivityEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceActivityEventCopyWith<_SpaceActivityEvent> get copyWith => __$SpaceActivityEventCopyWithImpl<_SpaceActivityEvent>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpaceActivityEvent'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('actorUserId', actorUserId))..add(DiagnosticsProperty('at', at))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('summary', summary))..add(DiagnosticsProperty('outcome', outcome))..add(DiagnosticsProperty('entityId', entityId))..add(DiagnosticsProperty('entityLabel', entityLabel))..add(DiagnosticsProperty('permission', permission))..add(DiagnosticsProperty('detail', detail));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceActivityEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.actorUserId, actorUserId) || other.actorUserId == actorUserId)&&(identical(other.at, at) || other.at == at)&&(identical(other.type, type) || other.type == type)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityLabel, entityLabel) || other.entityLabel == entityLabel)&&(identical(other.permission, permission) || other.permission == permission)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,id,spaceId,actorUserId,at,type,summary,outcome,entityId,entityLabel,permission,detail);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpaceActivityEvent(id: $id, spaceId: $spaceId, actorUserId: $actorUserId, at: $at, type: $type, summary: $summary, outcome: $outcome, entityId: $entityId, entityLabel: $entityLabel, permission: $permission, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$SpaceActivityEventCopyWith<$Res> implements $SpaceActivityEventCopyWith<$Res> {
  factory _$SpaceActivityEventCopyWith(_SpaceActivityEvent value, $Res Function(_SpaceActivityEvent) _then) = __$SpaceActivityEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String spaceId, String actorUserId, DateTime at, SpaceActivityType type, String summary, ActivityOutcome outcome, String? entityId, String? entityLabel, String? permission, String? detail
});




}
/// @nodoc
class __$SpaceActivityEventCopyWithImpl<$Res>
    implements _$SpaceActivityEventCopyWith<$Res> {
  __$SpaceActivityEventCopyWithImpl(this._self, this._then);

  final _SpaceActivityEvent _self;
  final $Res Function(_SpaceActivityEvent) _then;

/// Create a copy of SpaceActivityEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = null,Object? actorUserId = null,Object? at = null,Object? type = null,Object? summary = null,Object? outcome = null,Object? entityId = freezed,Object? entityLabel = freezed,Object? permission = freezed,Object? detail = freezed,}) {
  return _then(_SpaceActivityEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,actorUserId: null == actorUserId ? _self.actorUserId : actorUserId // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SpaceActivityType,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as ActivityOutcome,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,entityLabel: freezed == entityLabel ? _self.entityLabel : entityLabel // ignore: cast_nullable_to_non_nullable
as String?,permission: freezed == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PockitoNotification implements DiagnosticableTreeMixin {

 String get id; String get type; DateTime get at; String get title; String get body; String get destination; String? get entityId; bool get read; bool get dismissed;
/// Create a copy of PockitoNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PockitoNotificationCopyWith<PockitoNotification> get copyWith => _$PockitoNotificationCopyWithImpl<PockitoNotification>(this as PockitoNotification, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PockitoNotification'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('at', at))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('body', body))..add(DiagnosticsProperty('destination', destination))..add(DiagnosticsProperty('entityId', entityId))..add(DiagnosticsProperty('read', read))..add(DiagnosticsProperty('dismissed', dismissed));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PockitoNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.at, at) || other.at == at)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.read, read) || other.read == read)&&(identical(other.dismissed, dismissed) || other.dismissed == dismissed));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,at,title,body,destination,entityId,read,dismissed);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PockitoNotification(id: $id, type: $type, at: $at, title: $title, body: $body, destination: $destination, entityId: $entityId, read: $read, dismissed: $dismissed)';
}


}

/// @nodoc
abstract mixin class $PockitoNotificationCopyWith<$Res>  {
  factory $PockitoNotificationCopyWith(PockitoNotification value, $Res Function(PockitoNotification) _then) = _$PockitoNotificationCopyWithImpl;
@useResult
$Res call({
 String id, String type, DateTime at, String title, String body, String destination, String? entityId, bool read, bool dismissed
});




}
/// @nodoc
class _$PockitoNotificationCopyWithImpl<$Res>
    implements $PockitoNotificationCopyWith<$Res> {
  _$PockitoNotificationCopyWithImpl(this._self, this._then);

  final PockitoNotification _self;
  final $Res Function(PockitoNotification) _then;

/// Create a copy of PockitoNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? at = null,Object? title = null,Object? body = null,Object? destination = null,Object? entityId = freezed,Object? read = null,Object? dismissed = null,}) {
  return _then(PockitoNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,dismissed: null == dismissed ? _self.dismissed : dismissed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PockitoNotification].
extension PockitoNotificationPatterns on PockitoNotification {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PockitoNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PockitoNotification() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PockitoNotification value)  $default,){
final _that = this;
switch (_that) {
case _PockitoNotification():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PockitoNotification value)?  $default,){
final _that = this;
switch (_that) {
case _PockitoNotification() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  DateTime at,  String title,  String body,  String destination,  String? entityId,  bool read,  bool dismissed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PockitoNotification() when $default != null:
return $default(_that.id,_that.type,_that.at,_that.title,_that.body,_that.destination,_that.entityId,_that.read,_that.dismissed);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  DateTime at,  String title,  String body,  String destination,  String? entityId,  bool read,  bool dismissed)  $default,) {final _that = this;
switch (_that) {
case _PockitoNotification():
return $default(_that.id,_that.type,_that.at,_that.title,_that.body,_that.destination,_that.entityId,_that.read,_that.dismissed);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  DateTime at,  String title,  String body,  String destination,  String? entityId,  bool read,  bool dismissed)?  $default,) {final _that = this;
switch (_that) {
case _PockitoNotification() when $default != null:
return $default(_that.id,_that.type,_that.at,_that.title,_that.body,_that.destination,_that.entityId,_that.read,_that.dismissed);case _:
  return null;

}
}

}

/// @nodoc


class _PockitoNotification with DiagnosticableTreeMixin implements PockitoNotification {
  const _PockitoNotification({required this.id, required this.type, required this.at, required this.title, required this.body, required this.destination, this.entityId, this.read = false, this.dismissed = false});
  

@override final  String id;
@override final  String type;
@override final  DateTime at;
@override final  String title;
@override final  String body;
@override final  String destination;
@override final  String? entityId;
@override@JsonKey() final  bool read;
@override@JsonKey() final  bool dismissed;

/// Create a copy of PockitoNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PockitoNotificationCopyWith<_PockitoNotification> get copyWith => __$PockitoNotificationCopyWithImpl<_PockitoNotification>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PockitoNotification'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('at', at))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('body', body))..add(DiagnosticsProperty('destination', destination))..add(DiagnosticsProperty('entityId', entityId))..add(DiagnosticsProperty('read', read))..add(DiagnosticsProperty('dismissed', dismissed));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PockitoNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.at, at) || other.at == at)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.read, read) || other.read == read)&&(identical(other.dismissed, dismissed) || other.dismissed == dismissed));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,at,title,body,destination,entityId,read,dismissed);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PockitoNotification(id: $id, type: $type, at: $at, title: $title, body: $body, destination: $destination, entityId: $entityId, read: $read, dismissed: $dismissed)';
}


}

/// @nodoc
abstract mixin class _$PockitoNotificationCopyWith<$Res> implements $PockitoNotificationCopyWith<$Res> {
  factory _$PockitoNotificationCopyWith(_PockitoNotification value, $Res Function(_PockitoNotification) _then) = __$PockitoNotificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, DateTime at, String title, String body, String destination, String? entityId, bool read, bool dismissed
});




}
/// @nodoc
class __$PockitoNotificationCopyWithImpl<$Res>
    implements _$PockitoNotificationCopyWith<$Res> {
  __$PockitoNotificationCopyWithImpl(this._self, this._then);

  final _PockitoNotification _self;
  final $Res Function(_PockitoNotification) _then;

/// Create a copy of PockitoNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? at = null,Object? title = null,Object? body = null,Object? destination = null,Object? entityId = freezed,Object? read = null,Object? dismissed = null,}) {
  return _then(_PockitoNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,dismissed: null == dismissed ? _self.dismissed : dismissed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$NotificationPreferences implements DiagnosticableTreeMixin {

 bool get enabled; Set<String> get mutedEvents; bool get quietHoursOff;
/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferencesCopyWith<NotificationPreferences> get copyWith => _$NotificationPreferencesCopyWithImpl<NotificationPreferences>(this as NotificationPreferences, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NotificationPreferences'))
    ..add(DiagnosticsProperty('enabled', enabled))..add(DiagnosticsProperty('mutedEvents', mutedEvents))..add(DiagnosticsProperty('quietHoursOff', quietHoursOff));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferences&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.mutedEvents, mutedEvents)&&(identical(other.quietHoursOff, quietHoursOff) || other.quietHoursOff == quietHoursOff));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,const DeepCollectionEquality().hash(mutedEvents),quietHoursOff);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NotificationPreferences(enabled: $enabled, mutedEvents: $mutedEvents, quietHoursOff: $quietHoursOff)';
}


}

/// @nodoc
abstract mixin class $NotificationPreferencesCopyWith<$Res>  {
  factory $NotificationPreferencesCopyWith(NotificationPreferences value, $Res Function(NotificationPreferences) _then) = _$NotificationPreferencesCopyWithImpl;
@useResult
$Res call({
 bool enabled, Set<String> mutedEvents, bool quietHoursOff
});




}
/// @nodoc
class _$NotificationPreferencesCopyWithImpl<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final NotificationPreferences _self;
  final $Res Function(NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? mutedEvents = null,Object? quietHoursOff = null,}) {
  return _then(NotificationPreferences(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,mutedEvents: null == mutedEvents ? _self.mutedEvents : mutedEvents // ignore: cast_nullable_to_non_nullable
as Set<String>,quietHoursOff: null == quietHoursOff ? _self.quietHoursOff : quietHoursOff // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPreferences].
extension NotificationPreferencesPatterns on NotificationPreferences {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreferences value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  Set<String> mutedEvents,  bool quietHoursOff)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.enabled,_that.mutedEvents,_that.quietHoursOff);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  Set<String> mutedEvents,  bool quietHoursOff)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences():
return $default(_that.enabled,_that.mutedEvents,_that.quietHoursOff);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  Set<String> mutedEvents,  bool quietHoursOff)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.enabled,_that.mutedEvents,_that.quietHoursOff);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationPreferences with DiagnosticableTreeMixin implements NotificationPreferences {
  const _NotificationPreferences({this.enabled = true,  Set<String> mutedEvents = const <String>{}, this.quietHoursOff = true}): _mutedEvents = mutedEvents;
  

@override@JsonKey() final  bool enabled;
 final  Set<String> _mutedEvents;
@override@JsonKey() Set<String> get mutedEvents {
  if (_mutedEvents is EqualUnmodifiableSetView) return _mutedEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_mutedEvents);
}

@override@JsonKey() final  bool quietHoursOff;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferencesCopyWith<_NotificationPreferences> get copyWith => __$NotificationPreferencesCopyWithImpl<_NotificationPreferences>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NotificationPreferences'))
    ..add(DiagnosticsProperty('enabled', enabled))..add(DiagnosticsProperty('mutedEvents', mutedEvents))..add(DiagnosticsProperty('quietHoursOff', quietHoursOff));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferences&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._mutedEvents, _mutedEvents)&&(identical(other.quietHoursOff, quietHoursOff) || other.quietHoursOff == quietHoursOff));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,const DeepCollectionEquality().hash(_mutedEvents),quietHoursOff);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NotificationPreferences(enabled: $enabled, mutedEvents: $mutedEvents, quietHoursOff: $quietHoursOff)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferencesCopyWith<$Res> implements $NotificationPreferencesCopyWith<$Res> {
  factory _$NotificationPreferencesCopyWith(_NotificationPreferences value, $Res Function(_NotificationPreferences) _then) = __$NotificationPreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, Set<String> mutedEvents, bool quietHoursOff
});




}
/// @nodoc
class __$NotificationPreferencesCopyWithImpl<$Res>
    implements _$NotificationPreferencesCopyWith<$Res> {
  __$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final _NotificationPreferences _self;
  final $Res Function(_NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? mutedEvents = null,Object? quietHoursOff = null,}) {
  return _then(_NotificationPreferences(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,mutedEvents: null == mutedEvents ? _self._mutedEvents : mutedEvents // ignore: cast_nullable_to_non_nullable
as Set<String>,quietHoursOff: null == quietHoursOff ? _self.quietHoursOff : quietHoursOff // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$AiConnection implements DiagnosticableTreeMixin {

 String get id; String get name; String get status; List<String> get scopes; DateTime get createdAt; DateTime get lastUsedAt; bool get verified; int get writeCount; int get readCount;
/// Create a copy of AiConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiConnectionCopyWith<AiConnection> get copyWith => _$AiConnectionCopyWithImpl<AiConnection>(this as AiConnection, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AiConnection'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('scopes', scopes))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('lastUsedAt', lastUsedAt))..add(DiagnosticsProperty('verified', verified))..add(DiagnosticsProperty('writeCount', writeCount))..add(DiagnosticsProperty('readCount', readCount));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiConnection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.scopes, scopes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.writeCount, writeCount) || other.writeCount == writeCount)&&(identical(other.readCount, readCount) || other.readCount == readCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,status,const DeepCollectionEquality().hash(scopes),createdAt,lastUsedAt,verified,writeCount,readCount);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AiConnection(id: $id, name: $name, status: $status, scopes: $scopes, createdAt: $createdAt, lastUsedAt: $lastUsedAt, verified: $verified, writeCount: $writeCount, readCount: $readCount)';
}


}

/// @nodoc
abstract mixin class $AiConnectionCopyWith<$Res>  {
  factory $AiConnectionCopyWith(AiConnection value, $Res Function(AiConnection) _then) = _$AiConnectionCopyWithImpl;
@useResult
$Res call({
 String id, String name, String status, List<String> scopes, DateTime createdAt, DateTime lastUsedAt, bool verified, int writeCount, int readCount
});




}
/// @nodoc
class _$AiConnectionCopyWithImpl<$Res>
    implements $AiConnectionCopyWith<$Res> {
  _$AiConnectionCopyWithImpl(this._self, this._then);

  final AiConnection _self;
  final $Res Function(AiConnection) _then;

/// Create a copy of AiConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? scopes = null,Object? createdAt = null,Object? lastUsedAt = null,Object? verified = null,Object? writeCount = null,Object? readCount = null,}) {
  return _then(AiConnection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scopes: null == scopes ? _self.scopes : scopes // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastUsedAt: null == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,writeCount: null == writeCount ? _self.writeCount : writeCount // ignore: cast_nullable_to_non_nullable
as int,readCount: null == readCount ? _self.readCount : readCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AiConnection].
extension AiConnectionPatterns on AiConnection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiConnection() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiConnection value)  $default,){
final _that = this;
switch (_that) {
case _AiConnection():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiConnection value)?  $default,){
final _that = this;
switch (_that) {
case _AiConnection() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String status,  List<String> scopes,  DateTime createdAt,  DateTime lastUsedAt,  bool verified,  int writeCount,  int readCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiConnection() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.scopes,_that.createdAt,_that.lastUsedAt,_that.verified,_that.writeCount,_that.readCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String status,  List<String> scopes,  DateTime createdAt,  DateTime lastUsedAt,  bool verified,  int writeCount,  int readCount)  $default,) {final _that = this;
switch (_that) {
case _AiConnection():
return $default(_that.id,_that.name,_that.status,_that.scopes,_that.createdAt,_that.lastUsedAt,_that.verified,_that.writeCount,_that.readCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String status,  List<String> scopes,  DateTime createdAt,  DateTime lastUsedAt,  bool verified,  int writeCount,  int readCount)?  $default,) {final _that = this;
switch (_that) {
case _AiConnection() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.scopes,_that.createdAt,_that.lastUsedAt,_that.verified,_that.writeCount,_that.readCount);case _:
  return null;

}
}

}

/// @nodoc


class _AiConnection with DiagnosticableTreeMixin implements AiConnection {
  const _AiConnection({required this.id, required this.name, required this.status, required  List<String> scopes, required this.createdAt, required this.lastUsedAt, this.verified = true, this.writeCount = 0, this.readCount = 0}): _scopes = scopes;
  

@override final  String id;
@override final  String name;
@override final  String status;
 final  List<String> _scopes;
@override List<String> get scopes {
  if (_scopes is EqualUnmodifiableListView) return _scopes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scopes);
}

@override final  DateTime createdAt;
@override final  DateTime lastUsedAt;
@override@JsonKey() final  bool verified;
@override@JsonKey() final  int writeCount;
@override@JsonKey() final  int readCount;

/// Create a copy of AiConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiConnectionCopyWith<_AiConnection> get copyWith => __$AiConnectionCopyWithImpl<_AiConnection>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AiConnection'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('scopes', scopes))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('lastUsedAt', lastUsedAt))..add(DiagnosticsProperty('verified', verified))..add(DiagnosticsProperty('writeCount', writeCount))..add(DiagnosticsProperty('readCount', readCount));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiConnection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._scopes, _scopes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.writeCount, writeCount) || other.writeCount == writeCount)&&(identical(other.readCount, readCount) || other.readCount == readCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,status,const DeepCollectionEquality().hash(_scopes),createdAt,lastUsedAt,verified,writeCount,readCount);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AiConnection(id: $id, name: $name, status: $status, scopes: $scopes, createdAt: $createdAt, lastUsedAt: $lastUsedAt, verified: $verified, writeCount: $writeCount, readCount: $readCount)';
}


}

/// @nodoc
abstract mixin class _$AiConnectionCopyWith<$Res> implements $AiConnectionCopyWith<$Res> {
  factory _$AiConnectionCopyWith(_AiConnection value, $Res Function(_AiConnection) _then) = __$AiConnectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String status, List<String> scopes, DateTime createdAt, DateTime lastUsedAt, bool verified, int writeCount, int readCount
});




}
/// @nodoc
class __$AiConnectionCopyWithImpl<$Res>
    implements _$AiConnectionCopyWith<$Res> {
  __$AiConnectionCopyWithImpl(this._self, this._then);

  final _AiConnection _self;
  final $Res Function(_AiConnection) _then;

/// Create a copy of AiConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? scopes = null,Object? createdAt = null,Object? lastUsedAt = null,Object? verified = null,Object? writeCount = null,Object? readCount = null,}) {
  return _then(_AiConnection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scopes: null == scopes ? _self._scopes : scopes // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastUsedAt: null == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,writeCount: null == writeCount ? _self.writeCount : writeCount // ignore: cast_nullable_to_non_nullable
as int,readCount: null == readCount ? _self.readCount : readCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AiApproval implements DiagnosticableTreeMixin {

 String get id; String get client; String get summary; String get reason; String get impact; String get spaceId; String get fromUserId; String get toUserId; int get amountMinor; String get accountId; String get state;
/// Create a copy of AiApproval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiApprovalCopyWith<AiApproval> get copyWith => _$AiApprovalCopyWithImpl<AiApproval>(this as AiApproval, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AiApproval'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('client', client))..add(DiagnosticsProperty('summary', summary))..add(DiagnosticsProperty('reason', reason))..add(DiagnosticsProperty('impact', impact))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('fromUserId', fromUserId))..add(DiagnosticsProperty('toUserId', toUserId))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('accountId', accountId))..add(DiagnosticsProperty('state', state));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiApproval&&(identical(other.id, id) || other.id == id)&&(identical(other.client, client) || other.client == client)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.impact, impact) || other.impact == impact)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,id,client,summary,reason,impact,spaceId,fromUserId,toUserId,amountMinor,accountId,state);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AiApproval(id: $id, client: $client, summary: $summary, reason: $reason, impact: $impact, spaceId: $spaceId, fromUserId: $fromUserId, toUserId: $toUserId, amountMinor: $amountMinor, accountId: $accountId, state: $state)';
}


}

/// @nodoc
abstract mixin class $AiApprovalCopyWith<$Res>  {
  factory $AiApprovalCopyWith(AiApproval value, $Res Function(AiApproval) _then) = _$AiApprovalCopyWithImpl;
@useResult
$Res call({
 String id, String client, String summary, String reason, String impact, String spaceId, String fromUserId, String toUserId, int amountMinor, String accountId, String state
});




}
/// @nodoc
class _$AiApprovalCopyWithImpl<$Res>
    implements $AiApprovalCopyWith<$Res> {
  _$AiApprovalCopyWithImpl(this._self, this._then);

  final AiApproval _self;
  final $Res Function(AiApproval) _then;

/// Create a copy of AiApproval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? client = null,Object? summary = null,Object? reason = null,Object? impact = null,Object? spaceId = null,Object? fromUserId = null,Object? toUserId = null,Object? amountMinor = null,Object? accountId = null,Object? state = null,}) {
  return _then(AiApproval(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,impact: null == impact ? _self.impact : impact // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiApproval].
extension AiApprovalPatterns on AiApproval {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiApproval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiApproval() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiApproval value)  $default,){
final _that = this;
switch (_that) {
case _AiApproval():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiApproval value)?  $default,){
final _that = this;
switch (_that) {
case _AiApproval() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String client,  String summary,  String reason,  String impact,  String spaceId,  String fromUserId,  String toUserId,  int amountMinor,  String accountId,  String state)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiApproval() when $default != null:
return $default(_that.id,_that.client,_that.summary,_that.reason,_that.impact,_that.spaceId,_that.fromUserId,_that.toUserId,_that.amountMinor,_that.accountId,_that.state);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String client,  String summary,  String reason,  String impact,  String spaceId,  String fromUserId,  String toUserId,  int amountMinor,  String accountId,  String state)  $default,) {final _that = this;
switch (_that) {
case _AiApproval():
return $default(_that.id,_that.client,_that.summary,_that.reason,_that.impact,_that.spaceId,_that.fromUserId,_that.toUserId,_that.amountMinor,_that.accountId,_that.state);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String client,  String summary,  String reason,  String impact,  String spaceId,  String fromUserId,  String toUserId,  int amountMinor,  String accountId,  String state)?  $default,) {final _that = this;
switch (_that) {
case _AiApproval() when $default != null:
return $default(_that.id,_that.client,_that.summary,_that.reason,_that.impact,_that.spaceId,_that.fromUserId,_that.toUserId,_that.amountMinor,_that.accountId,_that.state);case _:
  return null;

}
}

}

/// @nodoc


class _AiApproval with DiagnosticableTreeMixin implements AiApproval {
  const _AiApproval({required this.id, required this.client, required this.summary, required this.reason, required this.impact, required this.spaceId, required this.fromUserId, required this.toUserId, required this.amountMinor, required this.accountId, this.state = 'PENDING'});
  

@override final  String id;
@override final  String client;
@override final  String summary;
@override final  String reason;
@override final  String impact;
@override final  String spaceId;
@override final  String fromUserId;
@override final  String toUserId;
@override final  int amountMinor;
@override final  String accountId;
@override@JsonKey() final  String state;

/// Create a copy of AiApproval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiApprovalCopyWith<_AiApproval> get copyWith => __$AiApprovalCopyWithImpl<_AiApproval>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AiApproval'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('client', client))..add(DiagnosticsProperty('summary', summary))..add(DiagnosticsProperty('reason', reason))..add(DiagnosticsProperty('impact', impact))..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('fromUserId', fromUserId))..add(DiagnosticsProperty('toUserId', toUserId))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('accountId', accountId))..add(DiagnosticsProperty('state', state));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiApproval&&(identical(other.id, id) || other.id == id)&&(identical(other.client, client) || other.client == client)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.impact, impact) || other.impact == impact)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,id,client,summary,reason,impact,spaceId,fromUserId,toUserId,amountMinor,accountId,state);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AiApproval(id: $id, client: $client, summary: $summary, reason: $reason, impact: $impact, spaceId: $spaceId, fromUserId: $fromUserId, toUserId: $toUserId, amountMinor: $amountMinor, accountId: $accountId, state: $state)';
}


}

/// @nodoc
abstract mixin class _$AiApprovalCopyWith<$Res> implements $AiApprovalCopyWith<$Res> {
  factory _$AiApprovalCopyWith(_AiApproval value, $Res Function(_AiApproval) _then) = __$AiApprovalCopyWithImpl;
@override @useResult
$Res call({
 String id, String client, String summary, String reason, String impact, String spaceId, String fromUserId, String toUserId, int amountMinor, String accountId, String state
});




}
/// @nodoc
class __$AiApprovalCopyWithImpl<$Res>
    implements _$AiApprovalCopyWith<$Res> {
  __$AiApprovalCopyWithImpl(this._self, this._then);

  final _AiApproval _self;
  final $Res Function(_AiApproval) _then;

/// Create a copy of AiApproval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? client = null,Object? summary = null,Object? reason = null,Object? impact = null,Object? spaceId = null,Object? fromUserId = null,Object? toUserId = null,Object? amountMinor = null,Object? accountId = null,Object? state = null,}) {
  return _then(_AiApproval(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,impact: null == impact ? _self.impact : impact // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$BudgetSnapshot implements DiagnosticableTreeMixin {

 Budget get budget; int get usedMinor; int get remainingMinor; double get progress; BudgetHealth get health; BudgetWindow get window;/// Carried in from the previous period when the budget rolls over.
 int get rolloverMinor;/// Straight-line projection of where the period ends at the current pace.
 int get forecastMinor;/// The same budget over the previous period, for comparison.
 int? get previousUsedMinor;
/// Create a copy of BudgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetSnapshotCopyWith<BudgetSnapshot> get copyWith => _$BudgetSnapshotCopyWithImpl<BudgetSnapshot>(this as BudgetSnapshot, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BudgetSnapshot'))
    ..add(DiagnosticsProperty('budget', budget))..add(DiagnosticsProperty('usedMinor', usedMinor))..add(DiagnosticsProperty('remainingMinor', remainingMinor))..add(DiagnosticsProperty('progress', progress))..add(DiagnosticsProperty('health', health))..add(DiagnosticsProperty('window', window))..add(DiagnosticsProperty('rolloverMinor', rolloverMinor))..add(DiagnosticsProperty('forecastMinor', forecastMinor))..add(DiagnosticsProperty('previousUsedMinor', previousUsedMinor));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetSnapshot&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.usedMinor, usedMinor) || other.usedMinor == usedMinor)&&(identical(other.remainingMinor, remainingMinor) || other.remainingMinor == remainingMinor)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.health, health) || other.health == health)&&(identical(other.window, window) || other.window == window)&&(identical(other.rolloverMinor, rolloverMinor) || other.rolloverMinor == rolloverMinor)&&(identical(other.forecastMinor, forecastMinor) || other.forecastMinor == forecastMinor)&&(identical(other.previousUsedMinor, previousUsedMinor) || other.previousUsedMinor == previousUsedMinor));
}


@override
int get hashCode => Object.hash(runtimeType,budget,usedMinor,remainingMinor,progress,health,window,rolloverMinor,forecastMinor,previousUsedMinor);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BudgetSnapshot(budget: $budget, usedMinor: $usedMinor, remainingMinor: $remainingMinor, progress: $progress, health: $health, window: $window, rolloverMinor: $rolloverMinor, forecastMinor: $forecastMinor, previousUsedMinor: $previousUsedMinor)';
}


}

/// @nodoc
abstract mixin class $BudgetSnapshotCopyWith<$Res>  {
  factory $BudgetSnapshotCopyWith(BudgetSnapshot value, $Res Function(BudgetSnapshot) _then) = _$BudgetSnapshotCopyWithImpl;
@useResult
$Res call({
 Budget budget, int usedMinor, int remainingMinor, double progress, BudgetHealth health, BudgetWindow window, int rolloverMinor, int forecastMinor, int? previousUsedMinor
});


$BudgetCopyWith<$Res> get budget;$BudgetWindowCopyWith<$Res> get window;

}
/// @nodoc
class _$BudgetSnapshotCopyWithImpl<$Res>
    implements $BudgetSnapshotCopyWith<$Res> {
  _$BudgetSnapshotCopyWithImpl(this._self, this._then);

  final BudgetSnapshot _self;
  final $Res Function(BudgetSnapshot) _then;

/// Create a copy of BudgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? budget = null,Object? usedMinor = null,Object? remainingMinor = null,Object? progress = null,Object? health = null,Object? window = null,Object? rolloverMinor = null,Object? forecastMinor = null,Object? previousUsedMinor = freezed,}) {
  return _then(BudgetSnapshot(
budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget,usedMinor: null == usedMinor ? _self.usedMinor : usedMinor // ignore: cast_nullable_to_non_nullable
as int,remainingMinor: null == remainingMinor ? _self.remainingMinor : remainingMinor // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as BudgetHealth,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as BudgetWindow,rolloverMinor: null == rolloverMinor ? _self.rolloverMinor : rolloverMinor // ignore: cast_nullable_to_non_nullable
as int,forecastMinor: null == forecastMinor ? _self.forecastMinor : forecastMinor // ignore: cast_nullable_to_non_nullable
as int,previousUsedMinor: freezed == previousUsedMinor ? _self.previousUsedMinor : previousUsedMinor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of BudgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetCopyWith<$Res> get budget {
  
  return $BudgetCopyWith<$Res>(_self.budget, (value) {
    return _then(_self.copyWith(budget: value));
  });
}/// Create a copy of BudgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetWindowCopyWith<$Res> get window {
  
  return $BudgetWindowCopyWith<$Res>(_self.window, (value) {
    return _then(_self.copyWith(window: value));
  });
}
}


/// Adds pattern-matching-related methods to [BudgetSnapshot].
extension BudgetSnapshotPatterns on BudgetSnapshot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetSnapshot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _BudgetSnapshot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetSnapshot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Budget budget,  int usedMinor,  int remainingMinor,  double progress,  BudgetHealth health,  BudgetWindow window,  int rolloverMinor,  int forecastMinor,  int? previousUsedMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetSnapshot() when $default != null:
return $default(_that.budget,_that.usedMinor,_that.remainingMinor,_that.progress,_that.health,_that.window,_that.rolloverMinor,_that.forecastMinor,_that.previousUsedMinor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Budget budget,  int usedMinor,  int remainingMinor,  double progress,  BudgetHealth health,  BudgetWindow window,  int rolloverMinor,  int forecastMinor,  int? previousUsedMinor)  $default,) {final _that = this;
switch (_that) {
case _BudgetSnapshot():
return $default(_that.budget,_that.usedMinor,_that.remainingMinor,_that.progress,_that.health,_that.window,_that.rolloverMinor,_that.forecastMinor,_that.previousUsedMinor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Budget budget,  int usedMinor,  int remainingMinor,  double progress,  BudgetHealth health,  BudgetWindow window,  int rolloverMinor,  int forecastMinor,  int? previousUsedMinor)?  $default,) {final _that = this;
switch (_that) {
case _BudgetSnapshot() when $default != null:
return $default(_that.budget,_that.usedMinor,_that.remainingMinor,_that.progress,_that.health,_that.window,_that.rolloverMinor,_that.forecastMinor,_that.previousUsedMinor);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetSnapshot with DiagnosticableTreeMixin implements BudgetSnapshot {
  const _BudgetSnapshot({required this.budget, required this.usedMinor, required this.remainingMinor, required this.progress, required this.health, required this.window, this.rolloverMinor = 0, this.forecastMinor = 0, this.previousUsedMinor});
  

@override final  Budget budget;
@override final  int usedMinor;
@override final  int remainingMinor;
@override final  double progress;
@override final  BudgetHealth health;
@override final  BudgetWindow window;
/// Carried in from the previous period when the budget rolls over.
@override@JsonKey() final  int rolloverMinor;
/// Straight-line projection of where the period ends at the current pace.
@override@JsonKey() final  int forecastMinor;
/// The same budget over the previous period, for comparison.
@override final  int? previousUsedMinor;

/// Create a copy of BudgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetSnapshotCopyWith<_BudgetSnapshot> get copyWith => __$BudgetSnapshotCopyWithImpl<_BudgetSnapshot>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BudgetSnapshot'))
    ..add(DiagnosticsProperty('budget', budget))..add(DiagnosticsProperty('usedMinor', usedMinor))..add(DiagnosticsProperty('remainingMinor', remainingMinor))..add(DiagnosticsProperty('progress', progress))..add(DiagnosticsProperty('health', health))..add(DiagnosticsProperty('window', window))..add(DiagnosticsProperty('rolloverMinor', rolloverMinor))..add(DiagnosticsProperty('forecastMinor', forecastMinor))..add(DiagnosticsProperty('previousUsedMinor', previousUsedMinor));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetSnapshot&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.usedMinor, usedMinor) || other.usedMinor == usedMinor)&&(identical(other.remainingMinor, remainingMinor) || other.remainingMinor == remainingMinor)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.health, health) || other.health == health)&&(identical(other.window, window) || other.window == window)&&(identical(other.rolloverMinor, rolloverMinor) || other.rolloverMinor == rolloverMinor)&&(identical(other.forecastMinor, forecastMinor) || other.forecastMinor == forecastMinor)&&(identical(other.previousUsedMinor, previousUsedMinor) || other.previousUsedMinor == previousUsedMinor));
}


@override
int get hashCode => Object.hash(runtimeType,budget,usedMinor,remainingMinor,progress,health,window,rolloverMinor,forecastMinor,previousUsedMinor);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BudgetSnapshot(budget: $budget, usedMinor: $usedMinor, remainingMinor: $remainingMinor, progress: $progress, health: $health, window: $window, rolloverMinor: $rolloverMinor, forecastMinor: $forecastMinor, previousUsedMinor: $previousUsedMinor)';
}


}

/// @nodoc
abstract mixin class _$BudgetSnapshotCopyWith<$Res> implements $BudgetSnapshotCopyWith<$Res> {
  factory _$BudgetSnapshotCopyWith(_BudgetSnapshot value, $Res Function(_BudgetSnapshot) _then) = __$BudgetSnapshotCopyWithImpl;
@override @useResult
$Res call({
 Budget budget, int usedMinor, int remainingMinor, double progress, BudgetHealth health, BudgetWindow window, int rolloverMinor, int forecastMinor, int? previousUsedMinor
});


@override $BudgetCopyWith<$Res> get budget;@override $BudgetWindowCopyWith<$Res> get window;

}
/// @nodoc
class __$BudgetSnapshotCopyWithImpl<$Res>
    implements _$BudgetSnapshotCopyWith<$Res> {
  __$BudgetSnapshotCopyWithImpl(this._self, this._then);

  final _BudgetSnapshot _self;
  final $Res Function(_BudgetSnapshot) _then;

/// Create a copy of BudgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? budget = null,Object? usedMinor = null,Object? remainingMinor = null,Object? progress = null,Object? health = null,Object? window = null,Object? rolloverMinor = null,Object? forecastMinor = null,Object? previousUsedMinor = freezed,}) {
  return _then(_BudgetSnapshot(
budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget,usedMinor: null == usedMinor ? _self.usedMinor : usedMinor // ignore: cast_nullable_to_non_nullable
as int,remainingMinor: null == remainingMinor ? _self.remainingMinor : remainingMinor // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as BudgetHealth,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as BudgetWindow,rolloverMinor: null == rolloverMinor ? _self.rolloverMinor : rolloverMinor // ignore: cast_nullable_to_non_nullable
as int,forecastMinor: null == forecastMinor ? _self.forecastMinor : forecastMinor // ignore: cast_nullable_to_non_nullable
as int,previousUsedMinor: freezed == previousUsedMinor ? _self.previousUsedMinor : previousUsedMinor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of BudgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetCopyWith<$Res> get budget {
  
  return $BudgetCopyWith<$Res>(_self.budget, (value) {
    return _then(_self.copyWith(budget: value));
  });
}/// Create a copy of BudgetSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetWindowCopyWith<$Res> get window {
  
  return $BudgetWindowCopyWith<$Res>(_self.window, (value) {
    return _then(_self.copyWith(window: value));
  });
}
}

/// @nodoc
mixin _$SharedSummary implements DiagnosticableTreeMixin {

 int get owedMinor; int get owingMinor; String get currency;
/// Create a copy of SharedSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedSummaryCopyWith<SharedSummary> get copyWith => _$SharedSummaryCopyWithImpl<SharedSummary>(this as SharedSummary, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SharedSummary'))
    ..add(DiagnosticsProperty('owedMinor', owedMinor))..add(DiagnosticsProperty('owingMinor', owingMinor))..add(DiagnosticsProperty('currency', currency));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedSummary&&(identical(other.owedMinor, owedMinor) || other.owedMinor == owedMinor)&&(identical(other.owingMinor, owingMinor) || other.owingMinor == owingMinor)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,owedMinor,owingMinor,currency);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SharedSummary(owedMinor: $owedMinor, owingMinor: $owingMinor, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $SharedSummaryCopyWith<$Res>  {
  factory $SharedSummaryCopyWith(SharedSummary value, $Res Function(SharedSummary) _then) = _$SharedSummaryCopyWithImpl;
@useResult
$Res call({
 int owedMinor, int owingMinor, String currency
});




}
/// @nodoc
class _$SharedSummaryCopyWithImpl<$Res>
    implements $SharedSummaryCopyWith<$Res> {
  _$SharedSummaryCopyWithImpl(this._self, this._then);

  final SharedSummary _self;
  final $Res Function(SharedSummary) _then;

/// Create a copy of SharedSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? owedMinor = null,Object? owingMinor = null,Object? currency = null,}) {
  return _then(SharedSummary(
owedMinor: null == owedMinor ? _self.owedMinor : owedMinor // ignore: cast_nullable_to_non_nullable
as int,owingMinor: null == owingMinor ? _self.owingMinor : owingMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedSummary].
extension SharedSummaryPatterns on SharedSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedSummary value)  $default,){
final _that = this;
switch (_that) {
case _SharedSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SharedSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int owedMinor,  int owingMinor,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedSummary() when $default != null:
return $default(_that.owedMinor,_that.owingMinor,_that.currency);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int owedMinor,  int owingMinor,  String currency)  $default,) {final _that = this;
switch (_that) {
case _SharedSummary():
return $default(_that.owedMinor,_that.owingMinor,_that.currency);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int owedMinor,  int owingMinor,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _SharedSummary() when $default != null:
return $default(_that.owedMinor,_that.owingMinor,_that.currency);case _:
  return null;

}
}

}

/// @nodoc


class _SharedSummary with DiagnosticableTreeMixin implements SharedSummary {
  const _SharedSummary({required this.owedMinor, required this.owingMinor, required this.currency});
  

@override final  int owedMinor;
@override final  int owingMinor;
@override final  String currency;

/// Create a copy of SharedSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedSummaryCopyWith<_SharedSummary> get copyWith => __$SharedSummaryCopyWithImpl<_SharedSummary>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SharedSummary'))
    ..add(DiagnosticsProperty('owedMinor', owedMinor))..add(DiagnosticsProperty('owingMinor', owingMinor))..add(DiagnosticsProperty('currency', currency));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedSummary&&(identical(other.owedMinor, owedMinor) || other.owedMinor == owedMinor)&&(identical(other.owingMinor, owingMinor) || other.owingMinor == owingMinor)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,owedMinor,owingMinor,currency);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SharedSummary(owedMinor: $owedMinor, owingMinor: $owingMinor, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$SharedSummaryCopyWith<$Res> implements $SharedSummaryCopyWith<$Res> {
  factory _$SharedSummaryCopyWith(_SharedSummary value, $Res Function(_SharedSummary) _then) = __$SharedSummaryCopyWithImpl;
@override @useResult
$Res call({
 int owedMinor, int owingMinor, String currency
});




}
/// @nodoc
class __$SharedSummaryCopyWithImpl<$Res>
    implements _$SharedSummaryCopyWith<$Res> {
  __$SharedSummaryCopyWithImpl(this._self, this._then);

  final _SharedSummary _self;
  final $Res Function(_SharedSummary) _then;

/// Create a copy of SharedSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? owedMinor = null,Object? owingMinor = null,Object? currency = null,}) {
  return _then(_SharedSummary(
owedMinor: null == owedMinor ? _self.owedMinor : owedMinor // ignore: cast_nullable_to_non_nullable
as int,owingMinor: null == owingMinor ? _self.owingMinor : owingMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SpendingSummary implements DiagnosticableTreeMixin {

 int get spentMinor; int get outflowMinor; int get incomeMinor; String get currency;
/// Create a copy of SpendingSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpendingSummaryCopyWith<SpendingSummary> get copyWith => _$SpendingSummaryCopyWithImpl<SpendingSummary>(this as SpendingSummary, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpendingSummary'))
    ..add(DiagnosticsProperty('spentMinor', spentMinor))..add(DiagnosticsProperty('outflowMinor', outflowMinor))..add(DiagnosticsProperty('incomeMinor', incomeMinor))..add(DiagnosticsProperty('currency', currency));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpendingSummary&&(identical(other.spentMinor, spentMinor) || other.spentMinor == spentMinor)&&(identical(other.outflowMinor, outflowMinor) || other.outflowMinor == outflowMinor)&&(identical(other.incomeMinor, incomeMinor) || other.incomeMinor == incomeMinor)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,spentMinor,outflowMinor,incomeMinor,currency);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpendingSummary(spentMinor: $spentMinor, outflowMinor: $outflowMinor, incomeMinor: $incomeMinor, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $SpendingSummaryCopyWith<$Res>  {
  factory $SpendingSummaryCopyWith(SpendingSummary value, $Res Function(SpendingSummary) _then) = _$SpendingSummaryCopyWithImpl;
@useResult
$Res call({
 int spentMinor, int outflowMinor, int incomeMinor, String currency
});




}
/// @nodoc
class _$SpendingSummaryCopyWithImpl<$Res>
    implements $SpendingSummaryCopyWith<$Res> {
  _$SpendingSummaryCopyWithImpl(this._self, this._then);

  final SpendingSummary _self;
  final $Res Function(SpendingSummary) _then;

/// Create a copy of SpendingSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spentMinor = null,Object? outflowMinor = null,Object? incomeMinor = null,Object? currency = null,}) {
  return _then(SpendingSummary(
spentMinor: null == spentMinor ? _self.spentMinor : spentMinor // ignore: cast_nullable_to_non_nullable
as int,outflowMinor: null == outflowMinor ? _self.outflowMinor : outflowMinor // ignore: cast_nullable_to_non_nullable
as int,incomeMinor: null == incomeMinor ? _self.incomeMinor : incomeMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpendingSummary].
extension SpendingSummaryPatterns on SpendingSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpendingSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpendingSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpendingSummary value)  $default,){
final _that = this;
switch (_that) {
case _SpendingSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpendingSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SpendingSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int spentMinor,  int outflowMinor,  int incomeMinor,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpendingSummary() when $default != null:
return $default(_that.spentMinor,_that.outflowMinor,_that.incomeMinor,_that.currency);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int spentMinor,  int outflowMinor,  int incomeMinor,  String currency)  $default,) {final _that = this;
switch (_that) {
case _SpendingSummary():
return $default(_that.spentMinor,_that.outflowMinor,_that.incomeMinor,_that.currency);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int spentMinor,  int outflowMinor,  int incomeMinor,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _SpendingSummary() when $default != null:
return $default(_that.spentMinor,_that.outflowMinor,_that.incomeMinor,_that.currency);case _:
  return null;

}
}

}

/// @nodoc


class _SpendingSummary with DiagnosticableTreeMixin implements SpendingSummary {
  const _SpendingSummary({required this.spentMinor, required this.outflowMinor, required this.incomeMinor, required this.currency});
  

@override final  int spentMinor;
@override final  int outflowMinor;
@override final  int incomeMinor;
@override final  String currency;

/// Create a copy of SpendingSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpendingSummaryCopyWith<_SpendingSummary> get copyWith => __$SpendingSummaryCopyWithImpl<_SpendingSummary>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SpendingSummary'))
    ..add(DiagnosticsProperty('spentMinor', spentMinor))..add(DiagnosticsProperty('outflowMinor', outflowMinor))..add(DiagnosticsProperty('incomeMinor', incomeMinor))..add(DiagnosticsProperty('currency', currency));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpendingSummary&&(identical(other.spentMinor, spentMinor) || other.spentMinor == spentMinor)&&(identical(other.outflowMinor, outflowMinor) || other.outflowMinor == outflowMinor)&&(identical(other.incomeMinor, incomeMinor) || other.incomeMinor == incomeMinor)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,spentMinor,outflowMinor,incomeMinor,currency);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SpendingSummary(spentMinor: $spentMinor, outflowMinor: $outflowMinor, incomeMinor: $incomeMinor, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$SpendingSummaryCopyWith<$Res> implements $SpendingSummaryCopyWith<$Res> {
  factory _$SpendingSummaryCopyWith(_SpendingSummary value, $Res Function(_SpendingSummary) _then) = __$SpendingSummaryCopyWithImpl;
@override @useResult
$Res call({
 int spentMinor, int outflowMinor, int incomeMinor, String currency
});




}
/// @nodoc
class __$SpendingSummaryCopyWithImpl<$Res>
    implements _$SpendingSummaryCopyWith<$Res> {
  __$SpendingSummaryCopyWithImpl(this._self, this._then);

  final _SpendingSummary _self;
  final $Res Function(_SpendingSummary) _then;

/// Create a copy of SpendingSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spentMinor = null,Object? outflowMinor = null,Object? incomeMinor = null,Object? currency = null,}) {
  return _then(_SpendingSummary(
spentMinor: null == spentMinor ? _self.spentMinor : spentMinor // ignore: cast_nullable_to_non_nullable
as int,outflowMinor: null == outflowMinor ? _self.outflowMinor : outflowMinor // ignore: cast_nullable_to_non_nullable
as int,incomeMinor: null == incomeMinor ? _self.incomeMinor : incomeMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SeriesPoint implements DiagnosticableTreeMixin {

 DateTime get at; int get valueMinor; String get label;
/// Create a copy of SeriesPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeriesPointCopyWith<SeriesPoint> get copyWith => _$SeriesPointCopyWithImpl<SeriesPoint>(this as SeriesPoint, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SeriesPoint'))
    ..add(DiagnosticsProperty('at', at))..add(DiagnosticsProperty('valueMinor', valueMinor))..add(DiagnosticsProperty('label', label));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeriesPoint&&(identical(other.at, at) || other.at == at)&&(identical(other.valueMinor, valueMinor) || other.valueMinor == valueMinor)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,at,valueMinor,label);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SeriesPoint(at: $at, valueMinor: $valueMinor, label: $label)';
}


}

/// @nodoc
abstract mixin class $SeriesPointCopyWith<$Res>  {
  factory $SeriesPointCopyWith(SeriesPoint value, $Res Function(SeriesPoint) _then) = _$SeriesPointCopyWithImpl;
@useResult
$Res call({
 DateTime at, int valueMinor, String label
});




}
/// @nodoc
class _$SeriesPointCopyWithImpl<$Res>
    implements $SeriesPointCopyWith<$Res> {
  _$SeriesPointCopyWithImpl(this._self, this._then);

  final SeriesPoint _self;
  final $Res Function(SeriesPoint) _then;

/// Create a copy of SeriesPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? at = null,Object? valueMinor = null,Object? label = null,}) {
  return _then(SeriesPoint(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,valueMinor: null == valueMinor ? _self.valueMinor : valueMinor // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SeriesPoint].
extension SeriesPointPatterns on SeriesPoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeriesPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeriesPoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeriesPoint value)  $default,){
final _that = this;
switch (_that) {
case _SeriesPoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeriesPoint value)?  $default,){
final _that = this;
switch (_that) {
case _SeriesPoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime at,  int valueMinor,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeriesPoint() when $default != null:
return $default(_that.at,_that.valueMinor,_that.label);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime at,  int valueMinor,  String label)  $default,) {final _that = this;
switch (_that) {
case _SeriesPoint():
return $default(_that.at,_that.valueMinor,_that.label);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime at,  int valueMinor,  String label)?  $default,) {final _that = this;
switch (_that) {
case _SeriesPoint() when $default != null:
return $default(_that.at,_that.valueMinor,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _SeriesPoint with DiagnosticableTreeMixin implements SeriesPoint {
  const _SeriesPoint({required this.at, required this.valueMinor, required this.label});
  

@override final  DateTime at;
@override final  int valueMinor;
@override final  String label;

/// Create a copy of SeriesPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeriesPointCopyWith<_SeriesPoint> get copyWith => __$SeriesPointCopyWithImpl<_SeriesPoint>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SeriesPoint'))
    ..add(DiagnosticsProperty('at', at))..add(DiagnosticsProperty('valueMinor', valueMinor))..add(DiagnosticsProperty('label', label));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeriesPoint&&(identical(other.at, at) || other.at == at)&&(identical(other.valueMinor, valueMinor) || other.valueMinor == valueMinor)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,at,valueMinor,label);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SeriesPoint(at: $at, valueMinor: $valueMinor, label: $label)';
}


}

/// @nodoc
abstract mixin class _$SeriesPointCopyWith<$Res> implements $SeriesPointCopyWith<$Res> {
  factory _$SeriesPointCopyWith(_SeriesPoint value, $Res Function(_SeriesPoint) _then) = __$SeriesPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime at, int valueMinor, String label
});




}
/// @nodoc
class __$SeriesPointCopyWithImpl<$Res>
    implements _$SeriesPointCopyWith<$Res> {
  __$SeriesPointCopyWithImpl(this._self, this._then);

  final _SeriesPoint _self;
  final $Res Function(_SeriesPoint) _then;

/// Create a copy of SeriesPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? at = null,Object? valueMinor = null,Object? label = null,}) {
  return _then(_SeriesPoint(
at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,valueMinor: null == valueMinor ? _self.valueMinor : valueMinor // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$CategorySlice implements DiagnosticableTreeMixin {

 String get id; String get label; int get valueMinor; int get colorIndex; String get icon;
/// Create a copy of CategorySlice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorySliceCopyWith<CategorySlice> get copyWith => _$CategorySliceCopyWithImpl<CategorySlice>(this as CategorySlice, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CategorySlice'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('label', label))..add(DiagnosticsProperty('valueMinor', valueMinor))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('icon', icon));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategorySlice&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.valueMinor, valueMinor) || other.valueMinor == valueMinor)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,valueMinor,colorIndex,icon);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CategorySlice(id: $id, label: $label, valueMinor: $valueMinor, colorIndex: $colorIndex, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $CategorySliceCopyWith<$Res>  {
  factory $CategorySliceCopyWith(CategorySlice value, $Res Function(CategorySlice) _then) = _$CategorySliceCopyWithImpl;
@useResult
$Res call({
 String id, String label, int valueMinor, int colorIndex, String icon
});




}
/// @nodoc
class _$CategorySliceCopyWithImpl<$Res>
    implements $CategorySliceCopyWith<$Res> {
  _$CategorySliceCopyWithImpl(this._self, this._then);

  final CategorySlice _self;
  final $Res Function(CategorySlice) _then;

/// Create a copy of CategorySlice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? valueMinor = null,Object? colorIndex = null,Object? icon = null,}) {
  return _then(CategorySlice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,valueMinor: null == valueMinor ? _self.valueMinor : valueMinor // ignore: cast_nullable_to_non_nullable
as int,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CategorySlice].
extension CategorySlicePatterns on CategorySlice {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategorySlice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategorySlice() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategorySlice value)  $default,){
final _that = this;
switch (_that) {
case _CategorySlice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategorySlice value)?  $default,){
final _that = this;
switch (_that) {
case _CategorySlice() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  int valueMinor,  int colorIndex,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategorySlice() when $default != null:
return $default(_that.id,_that.label,_that.valueMinor,_that.colorIndex,_that.icon);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  int valueMinor,  int colorIndex,  String icon)  $default,) {final _that = this;
switch (_that) {
case _CategorySlice():
return $default(_that.id,_that.label,_that.valueMinor,_that.colorIndex,_that.icon);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  int valueMinor,  int colorIndex,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _CategorySlice() when $default != null:
return $default(_that.id,_that.label,_that.valueMinor,_that.colorIndex,_that.icon);case _:
  return null;

}
}

}

/// @nodoc


class _CategorySlice with DiagnosticableTreeMixin implements CategorySlice {
  const _CategorySlice({required this.id, required this.label, required this.valueMinor, required this.colorIndex, required this.icon});
  

@override final  String id;
@override final  String label;
@override final  int valueMinor;
@override final  int colorIndex;
@override final  String icon;

/// Create a copy of CategorySlice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorySliceCopyWith<_CategorySlice> get copyWith => __$CategorySliceCopyWithImpl<_CategorySlice>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CategorySlice'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('label', label))..add(DiagnosticsProperty('valueMinor', valueMinor))..add(DiagnosticsProperty('colorIndex', colorIndex))..add(DiagnosticsProperty('icon', icon));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorySlice&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.valueMinor, valueMinor) || other.valueMinor == valueMinor)&&(identical(other.colorIndex, colorIndex) || other.colorIndex == colorIndex)&&(identical(other.icon, icon) || other.icon == icon));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,valueMinor,colorIndex,icon);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CategorySlice(id: $id, label: $label, valueMinor: $valueMinor, colorIndex: $colorIndex, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$CategorySliceCopyWith<$Res> implements $CategorySliceCopyWith<$Res> {
  factory _$CategorySliceCopyWith(_CategorySlice value, $Res Function(_CategorySlice) _then) = __$CategorySliceCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, int valueMinor, int colorIndex, String icon
});




}
/// @nodoc
class __$CategorySliceCopyWithImpl<$Res>
    implements _$CategorySliceCopyWith<$Res> {
  __$CategorySliceCopyWithImpl(this._self, this._then);

  final _CategorySlice _self;
  final $Res Function(_CategorySlice) _then;

/// Create a copy of CategorySlice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? valueMinor = null,Object? colorIndex = null,Object? icon = null,}) {
  return _then(_CategorySlice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,valueMinor: null == valueMinor ? _self.valueMinor : valueMinor // ignore: cast_nullable_to_non_nullable
as int,colorIndex: null == colorIndex ? _self.colorIndex : colorIndex // ignore: cast_nullable_to_non_nullable
as int,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PeriodComparison implements DiagnosticableTreeMixin {

 int get currentMinor; int get previousMinor; String get currency; String get previousLabel;
/// Create a copy of PeriodComparison
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PeriodComparisonCopyWith<PeriodComparison> get copyWith => _$PeriodComparisonCopyWithImpl<PeriodComparison>(this as PeriodComparison, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PeriodComparison'))
    ..add(DiagnosticsProperty('currentMinor', currentMinor))..add(DiagnosticsProperty('previousMinor', previousMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('previousLabel', previousLabel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PeriodComparison&&(identical(other.currentMinor, currentMinor) || other.currentMinor == currentMinor)&&(identical(other.previousMinor, previousMinor) || other.previousMinor == previousMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.previousLabel, previousLabel) || other.previousLabel == previousLabel));
}


@override
int get hashCode => Object.hash(runtimeType,currentMinor,previousMinor,currency,previousLabel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PeriodComparison(currentMinor: $currentMinor, previousMinor: $previousMinor, currency: $currency, previousLabel: $previousLabel)';
}


}

/// @nodoc
abstract mixin class $PeriodComparisonCopyWith<$Res>  {
  factory $PeriodComparisonCopyWith(PeriodComparison value, $Res Function(PeriodComparison) _then) = _$PeriodComparisonCopyWithImpl;
@useResult
$Res call({
 int currentMinor, int previousMinor, String currency, String previousLabel
});




}
/// @nodoc
class _$PeriodComparisonCopyWithImpl<$Res>
    implements $PeriodComparisonCopyWith<$Res> {
  _$PeriodComparisonCopyWithImpl(this._self, this._then);

  final PeriodComparison _self;
  final $Res Function(PeriodComparison) _then;

/// Create a copy of PeriodComparison
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentMinor = null,Object? previousMinor = null,Object? currency = null,Object? previousLabel = null,}) {
  return _then(PeriodComparison(
currentMinor: null == currentMinor ? _self.currentMinor : currentMinor // ignore: cast_nullable_to_non_nullable
as int,previousMinor: null == previousMinor ? _self.previousMinor : previousMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,previousLabel: null == previousLabel ? _self.previousLabel : previousLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PeriodComparison].
extension PeriodComparisonPatterns on PeriodComparison {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PeriodComparison value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PeriodComparison() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PeriodComparison value)  $default,){
final _that = this;
switch (_that) {
case _PeriodComparison():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PeriodComparison value)?  $default,){
final _that = this;
switch (_that) {
case _PeriodComparison() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentMinor,  int previousMinor,  String currency,  String previousLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PeriodComparison() when $default != null:
return $default(_that.currentMinor,_that.previousMinor,_that.currency,_that.previousLabel);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentMinor,  int previousMinor,  String currency,  String previousLabel)  $default,) {final _that = this;
switch (_that) {
case _PeriodComparison():
return $default(_that.currentMinor,_that.previousMinor,_that.currency,_that.previousLabel);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentMinor,  int previousMinor,  String currency,  String previousLabel)?  $default,) {final _that = this;
switch (_that) {
case _PeriodComparison() when $default != null:
return $default(_that.currentMinor,_that.previousMinor,_that.currency,_that.previousLabel);case _:
  return null;

}
}

}

/// @nodoc


class _PeriodComparison with DiagnosticableTreeMixin implements PeriodComparison {
  const _PeriodComparison({required this.currentMinor, required this.previousMinor, required this.currency, required this.previousLabel});
  

@override final  int currentMinor;
@override final  int previousMinor;
@override final  String currency;
@override final  String previousLabel;

/// Create a copy of PeriodComparison
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PeriodComparisonCopyWith<_PeriodComparison> get copyWith => __$PeriodComparisonCopyWithImpl<_PeriodComparison>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'PeriodComparison'))
    ..add(DiagnosticsProperty('currentMinor', currentMinor))..add(DiagnosticsProperty('previousMinor', previousMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('previousLabel', previousLabel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PeriodComparison&&(identical(other.currentMinor, currentMinor) || other.currentMinor == currentMinor)&&(identical(other.previousMinor, previousMinor) || other.previousMinor == previousMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.previousLabel, previousLabel) || other.previousLabel == previousLabel));
}


@override
int get hashCode => Object.hash(runtimeType,currentMinor,previousMinor,currency,previousLabel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'PeriodComparison(currentMinor: $currentMinor, previousMinor: $previousMinor, currency: $currency, previousLabel: $previousLabel)';
}


}

/// @nodoc
abstract mixin class _$PeriodComparisonCopyWith<$Res> implements $PeriodComparisonCopyWith<$Res> {
  factory _$PeriodComparisonCopyWith(_PeriodComparison value, $Res Function(_PeriodComparison) _then) = __$PeriodComparisonCopyWithImpl;
@override @useResult
$Res call({
 int currentMinor, int previousMinor, String currency, String previousLabel
});




}
/// @nodoc
class __$PeriodComparisonCopyWithImpl<$Res>
    implements _$PeriodComparisonCopyWith<$Res> {
  __$PeriodComparisonCopyWithImpl(this._self, this._then);

  final _PeriodComparison _self;
  final $Res Function(_PeriodComparison) _then;

/// Create a copy of PeriodComparison
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentMinor = null,Object? previousMinor = null,Object? currency = null,Object? previousLabel = null,}) {
  return _then(_PeriodComparison(
currentMinor: null == currentMinor ? _self.currentMinor : currentMinor // ignore: cast_nullable_to_non_nullable
as int,previousMinor: null == previousMinor ? _self.previousMinor : previousMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,previousLabel: null == previousLabel ? _self.previousLabel : previousLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$DebtEdge implements DiagnosticableTreeMixin {

 String get spaceId; String get fromUserId; String get toUserId; int get amountMinor; String get currency;
/// Create a copy of DebtEdge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtEdgeCopyWith<DebtEdge> get copyWith => _$DebtEdgeCopyWithImpl<DebtEdge>(this as DebtEdge, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DebtEdge'))
    ..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('fromUserId', fromUserId))..add(DiagnosticsProperty('toUserId', toUserId))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('currency', currency));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtEdge&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,spaceId,fromUserId,toUserId,amountMinor,currency);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DebtEdge(spaceId: $spaceId, fromUserId: $fromUserId, toUserId: $toUserId, amountMinor: $amountMinor, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $DebtEdgeCopyWith<$Res>  {
  factory $DebtEdgeCopyWith(DebtEdge value, $Res Function(DebtEdge) _then) = _$DebtEdgeCopyWithImpl;
@useResult
$Res call({
 String spaceId, String fromUserId, String toUserId, int amountMinor, String currency
});




}
/// @nodoc
class _$DebtEdgeCopyWithImpl<$Res>
    implements $DebtEdgeCopyWith<$Res> {
  _$DebtEdgeCopyWithImpl(this._self, this._then);

  final DebtEdge _self;
  final $Res Function(DebtEdge) _then;

/// Create a copy of DebtEdge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spaceId = null,Object? fromUserId = null,Object? toUserId = null,Object? amountMinor = null,Object? currency = null,}) {
  return _then(DebtEdge(
spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtEdge].
extension DebtEdgePatterns on DebtEdge {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtEdge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtEdge() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtEdge value)  $default,){
final _that = this;
switch (_that) {
case _DebtEdge():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtEdge value)?  $default,){
final _that = this;
switch (_that) {
case _DebtEdge() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String spaceId,  String fromUserId,  String toUserId,  int amountMinor,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtEdge() when $default != null:
return $default(_that.spaceId,_that.fromUserId,_that.toUserId,_that.amountMinor,_that.currency);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String spaceId,  String fromUserId,  String toUserId,  int amountMinor,  String currency)  $default,) {final _that = this;
switch (_that) {
case _DebtEdge():
return $default(_that.spaceId,_that.fromUserId,_that.toUserId,_that.amountMinor,_that.currency);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String spaceId,  String fromUserId,  String toUserId,  int amountMinor,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _DebtEdge() when $default != null:
return $default(_that.spaceId,_that.fromUserId,_that.toUserId,_that.amountMinor,_that.currency);case _:
  return null;

}
}

}

/// @nodoc


class _DebtEdge with DiagnosticableTreeMixin implements DebtEdge {
  const _DebtEdge({required this.spaceId, required this.fromUserId, required this.toUserId, required this.amountMinor, required this.currency});
  

@override final  String spaceId;
@override final  String fromUserId;
@override final  String toUserId;
@override final  int amountMinor;
@override final  String currency;

/// Create a copy of DebtEdge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtEdgeCopyWith<_DebtEdge> get copyWith => __$DebtEdgeCopyWithImpl<_DebtEdge>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DebtEdge'))
    ..add(DiagnosticsProperty('spaceId', spaceId))..add(DiagnosticsProperty('fromUserId', fromUserId))..add(DiagnosticsProperty('toUserId', toUserId))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('currency', currency));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtEdge&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,spaceId,fromUserId,toUserId,amountMinor,currency);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DebtEdge(spaceId: $spaceId, fromUserId: $fromUserId, toUserId: $toUserId, amountMinor: $amountMinor, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$DebtEdgeCopyWith<$Res> implements $DebtEdgeCopyWith<$Res> {
  factory _$DebtEdgeCopyWith(_DebtEdge value, $Res Function(_DebtEdge) _then) = __$DebtEdgeCopyWithImpl;
@override @useResult
$Res call({
 String spaceId, String fromUserId, String toUserId, int amountMinor, String currency
});




}
/// @nodoc
class __$DebtEdgeCopyWithImpl<$Res>
    implements _$DebtEdgeCopyWith<$Res> {
  __$DebtEdgeCopyWithImpl(this._self, this._then);

  final _DebtEdge _self;
  final $Res Function(_DebtEdge) _then;

/// Create a copy of DebtEdge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spaceId = null,Object? fromUserId = null,Object? toUserId = null,Object? amountMinor = null,Object? currency = null,}) {
  return _then(_DebtEdge(
spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ActionItem implements DiagnosticableTreeMixin {

 String get id; ActionItemKind get kind; String get title; String get detail; String get destination;/// Lower sorts first.
 int get priority;/// Money involved, when there is any. Kept as an amount rather than a
/// formatted string so the UI can render it in the reader's format.
 int? get amountMinor; String? get currency;
/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionItemCopyWith<ActionItem> get copyWith => _$ActionItemCopyWithImpl<ActionItem>(this as ActionItem, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ActionItem'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('kind', kind))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('detail', detail))..add(DiagnosticsProperty('destination', destination))..add(DiagnosticsProperty('priority', priority))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('currency', currency));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,title,detail,destination,priority,amountMinor,currency);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ActionItem(id: $id, kind: $kind, title: $title, detail: $detail, destination: $destination, priority: $priority, amountMinor: $amountMinor, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $ActionItemCopyWith<$Res>  {
  factory $ActionItemCopyWith(ActionItem value, $Res Function(ActionItem) _then) = _$ActionItemCopyWithImpl;
@useResult
$Res call({
 String id, ActionItemKind kind, String title, String detail, String destination, int priority, int? amountMinor, String? currency
});




}
/// @nodoc
class _$ActionItemCopyWithImpl<$Res>
    implements $ActionItemCopyWith<$Res> {
  _$ActionItemCopyWithImpl(this._self, this._then);

  final ActionItem _self;
  final $Res Function(ActionItem) _then;

/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? detail = null,Object? destination = null,Object? priority = null,Object? amountMinor = freezed,Object? currency = freezed,}) {
  return _then(ActionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ActionItemKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,amountMinor: freezed == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionItem].
extension ActionItemPatterns on ActionItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionItem value)  $default,){
final _that = this;
switch (_that) {
case _ActionItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionItem value)?  $default,){
final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ActionItemKind kind,  String title,  String detail,  String destination,  int priority,  int? amountMinor,  String? currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.detail,_that.destination,_that.priority,_that.amountMinor,_that.currency);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ActionItemKind kind,  String title,  String detail,  String destination,  int priority,  int? amountMinor,  String? currency)  $default,) {final _that = this;
switch (_that) {
case _ActionItem():
return $default(_that.id,_that.kind,_that.title,_that.detail,_that.destination,_that.priority,_that.amountMinor,_that.currency);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ActionItemKind kind,  String title,  String detail,  String destination,  int priority,  int? amountMinor,  String? currency)?  $default,) {final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.detail,_that.destination,_that.priority,_that.amountMinor,_that.currency);case _:
  return null;

}
}

}

/// @nodoc


class _ActionItem with DiagnosticableTreeMixin implements ActionItem {
  const _ActionItem({required this.id, required this.kind, required this.title, required this.detail, required this.destination, required this.priority, this.amountMinor, this.currency});
  

@override final  String id;
@override final  ActionItemKind kind;
@override final  String title;
@override final  String detail;
@override final  String destination;
/// Lower sorts first.
@override final  int priority;
/// Money involved, when there is any. Kept as an amount rather than a
/// formatted string so the UI can render it in the reader's format.
@override final  int? amountMinor;
@override final  String? currency;

/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionItemCopyWith<_ActionItem> get copyWith => __$ActionItemCopyWithImpl<_ActionItem>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ActionItem'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('kind', kind))..add(DiagnosticsProperty('title', title))..add(DiagnosticsProperty('detail', detail))..add(DiagnosticsProperty('destination', destination))..add(DiagnosticsProperty('priority', priority))..add(DiagnosticsProperty('amountMinor', amountMinor))..add(DiagnosticsProperty('currency', currency));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,title,detail,destination,priority,amountMinor,currency);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ActionItem(id: $id, kind: $kind, title: $title, detail: $detail, destination: $destination, priority: $priority, amountMinor: $amountMinor, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$ActionItemCopyWith<$Res> implements $ActionItemCopyWith<$Res> {
  factory _$ActionItemCopyWith(_ActionItem value, $Res Function(_ActionItem) _then) = __$ActionItemCopyWithImpl;
@override @useResult
$Res call({
 String id, ActionItemKind kind, String title, String detail, String destination, int priority, int? amountMinor, String? currency
});




}
/// @nodoc
class __$ActionItemCopyWithImpl<$Res>
    implements _$ActionItemCopyWith<$Res> {
  __$ActionItemCopyWithImpl(this._self, this._then);

  final _ActionItem _self;
  final $Res Function(_ActionItem) _then;

/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? detail = null,Object? destination = null,Object? priority = null,Object? amountMinor = freezed,Object? currency = freezed,}) {
  return _then(_ActionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ActionItemKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,amountMinor: freezed == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$FinancialHealth implements DiagnosticableTreeMixin {

 int get incomeMinor; int get outflowMinor; int get netMinor; int get disposableMinor; int get upcomingMinor; String get currency; double get savingsRate; List<CategorySlice> get unusual;
/// Create a copy of FinancialHealth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialHealthCopyWith<FinancialHealth> get copyWith => _$FinancialHealthCopyWithImpl<FinancialHealth>(this as FinancialHealth, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FinancialHealth'))
    ..add(DiagnosticsProperty('incomeMinor', incomeMinor))..add(DiagnosticsProperty('outflowMinor', outflowMinor))..add(DiagnosticsProperty('netMinor', netMinor))..add(DiagnosticsProperty('disposableMinor', disposableMinor))..add(DiagnosticsProperty('upcomingMinor', upcomingMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('savingsRate', savingsRate))..add(DiagnosticsProperty('unusual', unusual));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialHealth&&(identical(other.incomeMinor, incomeMinor) || other.incomeMinor == incomeMinor)&&(identical(other.outflowMinor, outflowMinor) || other.outflowMinor == outflowMinor)&&(identical(other.netMinor, netMinor) || other.netMinor == netMinor)&&(identical(other.disposableMinor, disposableMinor) || other.disposableMinor == disposableMinor)&&(identical(other.upcomingMinor, upcomingMinor) || other.upcomingMinor == upcomingMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&const DeepCollectionEquality().equals(other.unusual, unusual));
}


@override
int get hashCode => Object.hash(runtimeType,incomeMinor,outflowMinor,netMinor,disposableMinor,upcomingMinor,currency,savingsRate,const DeepCollectionEquality().hash(unusual));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FinancialHealth(incomeMinor: $incomeMinor, outflowMinor: $outflowMinor, netMinor: $netMinor, disposableMinor: $disposableMinor, upcomingMinor: $upcomingMinor, currency: $currency, savingsRate: $savingsRate, unusual: $unusual)';
}


}

/// @nodoc
abstract mixin class $FinancialHealthCopyWith<$Res>  {
  factory $FinancialHealthCopyWith(FinancialHealth value, $Res Function(FinancialHealth) _then) = _$FinancialHealthCopyWithImpl;
@useResult
$Res call({
 int incomeMinor, int outflowMinor, int netMinor, int disposableMinor, int upcomingMinor, String currency, double savingsRate, List<CategorySlice> unusual
});




}
/// @nodoc
class _$FinancialHealthCopyWithImpl<$Res>
    implements $FinancialHealthCopyWith<$Res> {
  _$FinancialHealthCopyWithImpl(this._self, this._then);

  final FinancialHealth _self;
  final $Res Function(FinancialHealth) _then;

/// Create a copy of FinancialHealth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? incomeMinor = null,Object? outflowMinor = null,Object? netMinor = null,Object? disposableMinor = null,Object? upcomingMinor = null,Object? currency = null,Object? savingsRate = null,Object? unusual = null,}) {
  return _then(FinancialHealth(
incomeMinor: null == incomeMinor ? _self.incomeMinor : incomeMinor // ignore: cast_nullable_to_non_nullable
as int,outflowMinor: null == outflowMinor ? _self.outflowMinor : outflowMinor // ignore: cast_nullable_to_non_nullable
as int,netMinor: null == netMinor ? _self.netMinor : netMinor // ignore: cast_nullable_to_non_nullable
as int,disposableMinor: null == disposableMinor ? _self.disposableMinor : disposableMinor // ignore: cast_nullable_to_non_nullable
as int,upcomingMinor: null == upcomingMinor ? _self.upcomingMinor : upcomingMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,savingsRate: null == savingsRate ? _self.savingsRate : savingsRate // ignore: cast_nullable_to_non_nullable
as double,unusual: null == unusual ? _self.unusual : unusual // ignore: cast_nullable_to_non_nullable
as List<CategorySlice>,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialHealth].
extension FinancialHealthPatterns on FinancialHealth {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialHealth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialHealth() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialHealth value)  $default,){
final _that = this;
switch (_that) {
case _FinancialHealth():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialHealth value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialHealth() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int incomeMinor,  int outflowMinor,  int netMinor,  int disposableMinor,  int upcomingMinor,  String currency,  double savingsRate,  List<CategorySlice> unusual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialHealth() when $default != null:
return $default(_that.incomeMinor,_that.outflowMinor,_that.netMinor,_that.disposableMinor,_that.upcomingMinor,_that.currency,_that.savingsRate,_that.unusual);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int incomeMinor,  int outflowMinor,  int netMinor,  int disposableMinor,  int upcomingMinor,  String currency,  double savingsRate,  List<CategorySlice> unusual)  $default,) {final _that = this;
switch (_that) {
case _FinancialHealth():
return $default(_that.incomeMinor,_that.outflowMinor,_that.netMinor,_that.disposableMinor,_that.upcomingMinor,_that.currency,_that.savingsRate,_that.unusual);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int incomeMinor,  int outflowMinor,  int netMinor,  int disposableMinor,  int upcomingMinor,  String currency,  double savingsRate,  List<CategorySlice> unusual)?  $default,) {final _that = this;
switch (_that) {
case _FinancialHealth() when $default != null:
return $default(_that.incomeMinor,_that.outflowMinor,_that.netMinor,_that.disposableMinor,_that.upcomingMinor,_that.currency,_that.savingsRate,_that.unusual);case _:
  return null;

}
}

}

/// @nodoc


class _FinancialHealth with DiagnosticableTreeMixin implements FinancialHealth {
  const _FinancialHealth({required this.incomeMinor, required this.outflowMinor, required this.netMinor, required this.disposableMinor, required this.upcomingMinor, required this.currency, required this.savingsRate,  List<CategorySlice> unusual = const <CategorySlice>[]}): _unusual = unusual;
  

@override final  int incomeMinor;
@override final  int outflowMinor;
@override final  int netMinor;
@override final  int disposableMinor;
@override final  int upcomingMinor;
@override final  String currency;
@override final  double savingsRate;
 final  List<CategorySlice> _unusual;
@override@JsonKey() List<CategorySlice> get unusual {
  if (_unusual is EqualUnmodifiableListView) return _unusual;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unusual);
}


/// Create a copy of FinancialHealth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialHealthCopyWith<_FinancialHealth> get copyWith => __$FinancialHealthCopyWithImpl<_FinancialHealth>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'FinancialHealth'))
    ..add(DiagnosticsProperty('incomeMinor', incomeMinor))..add(DiagnosticsProperty('outflowMinor', outflowMinor))..add(DiagnosticsProperty('netMinor', netMinor))..add(DiagnosticsProperty('disposableMinor', disposableMinor))..add(DiagnosticsProperty('upcomingMinor', upcomingMinor))..add(DiagnosticsProperty('currency', currency))..add(DiagnosticsProperty('savingsRate', savingsRate))..add(DiagnosticsProperty('unusual', unusual));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialHealth&&(identical(other.incomeMinor, incomeMinor) || other.incomeMinor == incomeMinor)&&(identical(other.outflowMinor, outflowMinor) || other.outflowMinor == outflowMinor)&&(identical(other.netMinor, netMinor) || other.netMinor == netMinor)&&(identical(other.disposableMinor, disposableMinor) || other.disposableMinor == disposableMinor)&&(identical(other.upcomingMinor, upcomingMinor) || other.upcomingMinor == upcomingMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&const DeepCollectionEquality().equals(other._unusual, _unusual));
}


@override
int get hashCode => Object.hash(runtimeType,incomeMinor,outflowMinor,netMinor,disposableMinor,upcomingMinor,currency,savingsRate,const DeepCollectionEquality().hash(_unusual));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'FinancialHealth(incomeMinor: $incomeMinor, outflowMinor: $outflowMinor, netMinor: $netMinor, disposableMinor: $disposableMinor, upcomingMinor: $upcomingMinor, currency: $currency, savingsRate: $savingsRate, unusual: $unusual)';
}


}

/// @nodoc
abstract mixin class _$FinancialHealthCopyWith<$Res> implements $FinancialHealthCopyWith<$Res> {
  factory _$FinancialHealthCopyWith(_FinancialHealth value, $Res Function(_FinancialHealth) _then) = __$FinancialHealthCopyWithImpl;
@override @useResult
$Res call({
 int incomeMinor, int outflowMinor, int netMinor, int disposableMinor, int upcomingMinor, String currency, double savingsRate, List<CategorySlice> unusual
});




}
/// @nodoc
class __$FinancialHealthCopyWithImpl<$Res>
    implements _$FinancialHealthCopyWith<$Res> {
  __$FinancialHealthCopyWithImpl(this._self, this._then);

  final _FinancialHealth _self;
  final $Res Function(_FinancialHealth) _then;

/// Create a copy of FinancialHealth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? incomeMinor = null,Object? outflowMinor = null,Object? netMinor = null,Object? disposableMinor = null,Object? upcomingMinor = null,Object? currency = null,Object? savingsRate = null,Object? unusual = null,}) {
  return _then(_FinancialHealth(
incomeMinor: null == incomeMinor ? _self.incomeMinor : incomeMinor // ignore: cast_nullable_to_non_nullable
as int,outflowMinor: null == outflowMinor ? _self.outflowMinor : outflowMinor // ignore: cast_nullable_to_non_nullable
as int,netMinor: null == netMinor ? _self.netMinor : netMinor // ignore: cast_nullable_to_non_nullable
as int,disposableMinor: null == disposableMinor ? _self.disposableMinor : disposableMinor // ignore: cast_nullable_to_non_nullable
as int,upcomingMinor: null == upcomingMinor ? _self.upcomingMinor : upcomingMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,savingsRate: null == savingsRate ? _self.savingsRate : savingsRate // ignore: cast_nullable_to_non_nullable
as double,unusual: null == unusual ? _self._unusual : unusual // ignore: cast_nullable_to_non_nullable
as List<CategorySlice>,
  ));
}


}

/// @nodoc
mixin _$SavedView implements DiagnosticableTreeMixin {

 String get id; String get name; Map<String, List<String>> get selections; String get period; DateTime? get from; DateTime? get to; String get query; String get sort;
/// Create a copy of SavedView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedViewCopyWith<SavedView> get copyWith => _$SavedViewCopyWithImpl<SavedView>(this as SavedView, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SavedView'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('selections', selections))..add(DiagnosticsProperty('period', period))..add(DiagnosticsProperty('from', from))..add(DiagnosticsProperty('to', to))..add(DiagnosticsProperty('query', query))..add(DiagnosticsProperty('sort', sort));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedView&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.selections, selections)&&(identical(other.period, period) || other.period == period)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.query, query) || other.query == query)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(selections),period,from,to,query,sort);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SavedView(id: $id, name: $name, selections: $selections, period: $period, from: $from, to: $to, query: $query, sort: $sort)';
}


}

/// @nodoc
abstract mixin class $SavedViewCopyWith<$Res>  {
  factory $SavedViewCopyWith(SavedView value, $Res Function(SavedView) _then) = _$SavedViewCopyWithImpl;
@useResult
$Res call({
 String id, String name, Map<String, List<String>> selections, String period, DateTime? from, DateTime? to, String query, String sort
});




}
/// @nodoc
class _$SavedViewCopyWithImpl<$Res>
    implements $SavedViewCopyWith<$Res> {
  _$SavedViewCopyWithImpl(this._self, this._then);

  final SavedView _self;
  final $Res Function(SavedView) _then;

/// Create a copy of SavedView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? selections = null,Object? period = null,Object? from = freezed,Object? to = freezed,Object? query = null,Object? sort = null,}) {
  return _then(SavedView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,selections: null == selections ? _self.selections : selections // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedView].
extension SavedViewPatterns on SavedView {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedView() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedView value)  $default,){
final _that = this;
switch (_that) {
case _SavedView():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedView value)?  $default,){
final _that = this;
switch (_that) {
case _SavedView() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  Map<String, List<String>> selections,  String period,  DateTime? from,  DateTime? to,  String query,  String sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedView() when $default != null:
return $default(_that.id,_that.name,_that.selections,_that.period,_that.from,_that.to,_that.query,_that.sort);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  Map<String, List<String>> selections,  String period,  DateTime? from,  DateTime? to,  String query,  String sort)  $default,) {final _that = this;
switch (_that) {
case _SavedView():
return $default(_that.id,_that.name,_that.selections,_that.period,_that.from,_that.to,_that.query,_that.sort);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  Map<String, List<String>> selections,  String period,  DateTime? from,  DateTime? to,  String query,  String sort)?  $default,) {final _that = this;
switch (_that) {
case _SavedView() when $default != null:
return $default(_that.id,_that.name,_that.selections,_that.period,_that.from,_that.to,_that.query,_that.sort);case _:
  return null;

}
}

}

/// @nodoc


class _SavedView with DiagnosticableTreeMixin implements SavedView {
  const _SavedView({required this.id, required this.name, required  Map<String, List<String>> selections, required this.period, this.from, this.to, this.query = '', this.sort = 'dateDesc'}): _selections = selections;
  

@override final  String id;
@override final  String name;
 final  Map<String, List<String>> _selections;
@override Map<String, List<String>> get selections {
  if (_selections is EqualUnmodifiableMapView) return _selections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_selections);
}

@override final  String period;
@override final  DateTime? from;
@override final  DateTime? to;
@override@JsonKey() final  String query;
@override@JsonKey() final  String sort;

/// Create a copy of SavedView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedViewCopyWith<_SavedView> get copyWith => __$SavedViewCopyWithImpl<_SavedView>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SavedView'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('selections', selections))..add(DiagnosticsProperty('period', period))..add(DiagnosticsProperty('from', from))..add(DiagnosticsProperty('to', to))..add(DiagnosticsProperty('query', query))..add(DiagnosticsProperty('sort', sort));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedView&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._selections, _selections)&&(identical(other.period, period) || other.period == period)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.query, query) || other.query == query)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_selections),period,from,to,query,sort);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SavedView(id: $id, name: $name, selections: $selections, period: $period, from: $from, to: $to, query: $query, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$SavedViewCopyWith<$Res> implements $SavedViewCopyWith<$Res> {
  factory _$SavedViewCopyWith(_SavedView value, $Res Function(_SavedView) _then) = __$SavedViewCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, Map<String, List<String>> selections, String period, DateTime? from, DateTime? to, String query, String sort
});




}
/// @nodoc
class __$SavedViewCopyWithImpl<$Res>
    implements _$SavedViewCopyWith<$Res> {
  __$SavedViewCopyWithImpl(this._self, this._then);

  final _SavedView _self;
  final $Res Function(_SavedView) _then;

/// Create a copy of SavedView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? selections = null,Object? period = null,Object? from = freezed,Object? to = freezed,Object? query = null,Object? sort = null,}) {
  return _then(_SavedView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,selections: null == selections ? _self._selections : selections // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ImportPreview implements DiagnosticableTreeMixin {

 List<ImportRow> get rows; List<String> get headers;
/// Create a copy of ImportPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportPreviewCopyWith<ImportPreview> get copyWith => _$ImportPreviewCopyWithImpl<ImportPreview>(this as ImportPreview, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ImportPreview'))
    ..add(DiagnosticsProperty('rows', rows))..add(DiagnosticsProperty('headers', headers));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportPreview&&const DeepCollectionEquality().equals(other.rows, rows)&&const DeepCollectionEquality().equals(other.headers, headers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rows),const DeepCollectionEquality().hash(headers));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ImportPreview(rows: $rows, headers: $headers)';
}


}

/// @nodoc
abstract mixin class $ImportPreviewCopyWith<$Res>  {
  factory $ImportPreviewCopyWith(ImportPreview value, $Res Function(ImportPreview) _then) = _$ImportPreviewCopyWithImpl;
@useResult
$Res call({
 List<ImportRow> rows, List<String> headers
});




}
/// @nodoc
class _$ImportPreviewCopyWithImpl<$Res>
    implements $ImportPreviewCopyWith<$Res> {
  _$ImportPreviewCopyWithImpl(this._self, this._then);

  final ImportPreview _self;
  final $Res Function(ImportPreview) _then;

/// Create a copy of ImportPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rows = null,Object? headers = null,}) {
  return _then(ImportPreview(
rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<ImportRow>,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportPreview].
extension ImportPreviewPatterns on ImportPreview {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportPreview() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportPreview value)  $default,){
final _that = this;
switch (_that) {
case _ImportPreview():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportPreview value)?  $default,){
final _that = this;
switch (_that) {
case _ImportPreview() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ImportRow> rows,  List<String> headers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportPreview() when $default != null:
return $default(_that.rows,_that.headers);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ImportRow> rows,  List<String> headers)  $default,) {final _that = this;
switch (_that) {
case _ImportPreview():
return $default(_that.rows,_that.headers);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ImportRow> rows,  List<String> headers)?  $default,) {final _that = this;
switch (_that) {
case _ImportPreview() when $default != null:
return $default(_that.rows,_that.headers);case _:
  return null;

}
}

}

/// @nodoc


class _ImportPreview with DiagnosticableTreeMixin implements ImportPreview {
  const _ImportPreview({required  List<ImportRow> rows, required  List<String> headers}): _rows = rows,_headers = headers;
  

 final  List<ImportRow> _rows;
@override List<ImportRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

 final  List<String> _headers;
@override List<String> get headers {
  if (_headers is EqualUnmodifiableListView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_headers);
}


/// Create a copy of ImportPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportPreviewCopyWith<_ImportPreview> get copyWith => __$ImportPreviewCopyWithImpl<_ImportPreview>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ImportPreview'))
    ..add(DiagnosticsProperty('rows', rows))..add(DiagnosticsProperty('headers', headers));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportPreview&&const DeepCollectionEquality().equals(other._rows, _rows)&&const DeepCollectionEquality().equals(other._headers, _headers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rows),const DeepCollectionEquality().hash(_headers));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ImportPreview(rows: $rows, headers: $headers)';
}


}

/// @nodoc
abstract mixin class _$ImportPreviewCopyWith<$Res> implements $ImportPreviewCopyWith<$Res> {
  factory _$ImportPreviewCopyWith(_ImportPreview value, $Res Function(_ImportPreview) _then) = __$ImportPreviewCopyWithImpl;
@override @useResult
$Res call({
 List<ImportRow> rows, List<String> headers
});




}
/// @nodoc
class __$ImportPreviewCopyWithImpl<$Res>
    implements _$ImportPreviewCopyWith<$Res> {
  __$ImportPreviewCopyWithImpl(this._self, this._then);

  final _ImportPreview _self;
  final $Res Function(_ImportPreview) _then;

/// Create a copy of ImportPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rows = null,Object? headers = null,}) {
  return _then(_ImportPreview(
rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<ImportRow>,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$ImportRow implements DiagnosticableTreeMixin {

 int get lineNumber; ImportRowState get state; String get description; MoneyTransaction? get transaction; String? get problem;
/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportRowCopyWith<ImportRow> get copyWith => _$ImportRowCopyWithImpl<ImportRow>(this as ImportRow, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ImportRow'))
    ..add(DiagnosticsProperty('lineNumber', lineNumber))..add(DiagnosticsProperty('state', state))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('transaction', transaction))..add(DiagnosticsProperty('problem', problem));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportRow&&(identical(other.lineNumber, lineNumber) || other.lineNumber == lineNumber)&&(identical(other.state, state) || other.state == state)&&(identical(other.description, description) || other.description == description)&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.problem, problem) || other.problem == problem));
}


@override
int get hashCode => Object.hash(runtimeType,lineNumber,state,description,transaction,problem);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ImportRow(lineNumber: $lineNumber, state: $state, description: $description, transaction: $transaction, problem: $problem)';
}


}

/// @nodoc
abstract mixin class $ImportRowCopyWith<$Res>  {
  factory $ImportRowCopyWith(ImportRow value, $Res Function(ImportRow) _then) = _$ImportRowCopyWithImpl;
@useResult
$Res call({
 int lineNumber, ImportRowState state, String description, MoneyTransaction? transaction, String? problem
});


$MoneyTransactionCopyWith<$Res>? get transaction;

}
/// @nodoc
class _$ImportRowCopyWithImpl<$Res>
    implements $ImportRowCopyWith<$Res> {
  _$ImportRowCopyWithImpl(this._self, this._then);

  final ImportRow _self;
  final $Res Function(ImportRow) _then;

/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lineNumber = null,Object? state = null,Object? description = null,Object? transaction = freezed,Object? problem = freezed,}) {
  return _then(ImportRow(
lineNumber: null == lineNumber ? _self.lineNumber : lineNumber // ignore: cast_nullable_to_non_nullable
as int,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ImportRowState,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,transaction: freezed == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as MoneyTransaction?,problem: freezed == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyTransactionCopyWith<$Res>? get transaction {
    if (_self.transaction == null) {
    return null;
  }

  return $MoneyTransactionCopyWith<$Res>(_self.transaction!, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}


/// Adds pattern-matching-related methods to [ImportRow].
extension ImportRowPatterns on ImportRow {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportRow() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportRow value)  $default,){
final _that = this;
switch (_that) {
case _ImportRow():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportRow value)?  $default,){
final _that = this;
switch (_that) {
case _ImportRow() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int lineNumber,  ImportRowState state,  String description,  MoneyTransaction? transaction,  String? problem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportRow() when $default != null:
return $default(_that.lineNumber,_that.state,_that.description,_that.transaction,_that.problem);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int lineNumber,  ImportRowState state,  String description,  MoneyTransaction? transaction,  String? problem)  $default,) {final _that = this;
switch (_that) {
case _ImportRow():
return $default(_that.lineNumber,_that.state,_that.description,_that.transaction,_that.problem);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int lineNumber,  ImportRowState state,  String description,  MoneyTransaction? transaction,  String? problem)?  $default,) {final _that = this;
switch (_that) {
case _ImportRow() when $default != null:
return $default(_that.lineNumber,_that.state,_that.description,_that.transaction,_that.problem);case _:
  return null;

}
}

}

/// @nodoc


class _ImportRow with DiagnosticableTreeMixin implements ImportRow {
  const _ImportRow({required this.lineNumber, required this.state, required this.description, this.transaction, this.problem});
  

@override final  int lineNumber;
@override final  ImportRowState state;
@override final  String description;
@override final  MoneyTransaction? transaction;
@override final  String? problem;

/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportRowCopyWith<_ImportRow> get copyWith => __$ImportRowCopyWithImpl<_ImportRow>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ImportRow'))
    ..add(DiagnosticsProperty('lineNumber', lineNumber))..add(DiagnosticsProperty('state', state))..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('transaction', transaction))..add(DiagnosticsProperty('problem', problem));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportRow&&(identical(other.lineNumber, lineNumber) || other.lineNumber == lineNumber)&&(identical(other.state, state) || other.state == state)&&(identical(other.description, description) || other.description == description)&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.problem, problem) || other.problem == problem));
}


@override
int get hashCode => Object.hash(runtimeType,lineNumber,state,description,transaction,problem);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ImportRow(lineNumber: $lineNumber, state: $state, description: $description, transaction: $transaction, problem: $problem)';
}


}

/// @nodoc
abstract mixin class _$ImportRowCopyWith<$Res> implements $ImportRowCopyWith<$Res> {
  factory _$ImportRowCopyWith(_ImportRow value, $Res Function(_ImportRow) _then) = __$ImportRowCopyWithImpl;
@override @useResult
$Res call({
 int lineNumber, ImportRowState state, String description, MoneyTransaction? transaction, String? problem
});


@override $MoneyTransactionCopyWith<$Res>? get transaction;

}
/// @nodoc
class __$ImportRowCopyWithImpl<$Res>
    implements _$ImportRowCopyWith<$Res> {
  __$ImportRowCopyWithImpl(this._self, this._then);

  final _ImportRow _self;
  final $Res Function(_ImportRow) _then;

/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lineNumber = null,Object? state = null,Object? description = null,Object? transaction = freezed,Object? problem = freezed,}) {
  return _then(_ImportRow(
lineNumber: null == lineNumber ? _self.lineNumber : lineNumber // ignore: cast_nullable_to_non_nullable
as int,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ImportRowState,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,transaction: freezed == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as MoneyTransaction?,problem: freezed == problem ? _self.problem : problem // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ImportRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyTransactionCopyWith<$Res>? get transaction {
    if (_self.transaction == null) {
    return null;
  }

  return $MoneyTransactionCopyWith<$Res>(_self.transaction!, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}

// dart format on
