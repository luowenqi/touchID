# touchID
调用方法

```
[TouchID shared];
[touchid verifyTouchID:^(BOOL state, NSString *message){
//state :指纹识别结果
//message :提示语
}
```
