# react-native-sum-up

## Getting started

`$ npm install react-native-sum-up --save`

### iOS
`$ cd ios/`
`$ pod install`

### Android

In `android/build.gradle`, add:
```
allprojects {
    repositories {
        ...
        maven { url 'https://maven.sumup.com/releases' } // -> this
        ...
    }
}
```

In `android/app/build.gradle`, add:
```
dependencies {
    ...
    implementation 'com.sumup:merchant-sdk:3.2.0' // -> this
    ...
}
```

In `MainActivity.java`, add:
```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    ...
    SumUpState.init(this); // -> this
    ...
}
```