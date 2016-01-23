# iBT Indoor iOS SDK

#SDK使用步骤
#1. 解压开发包,并将Library目录下的ibt_indoor.framework文件拖入您的工程(device_version对应真机调试版本,simulator_version对应模拟器版本)
#2. 将ibt_indoor.framework/indoor_resource.bundle加入到"copy Bundle Resources"
#3. 将ibt_indoor.framework，libz，libc，libstdc++加入到“Link Binary with Libraries”
#4. 在Info.plist中增加“App Transport Security Settings”->"Allow Arbitrary Loads"=YES，“NSLocationWhenInUseUsageDescription”="en"
#5. 引用头文件并进行相应的接口调用
#6. 具体API说明请参见包内离线文档
注：若是Xcode7版本，在Build Settings中设置“Enable Bitcode”=No


#SDK基本布局
#Library: 库和头文件，支持第三方应用开发
#Examples: 示例程序，可在XCode下编译运行
#Documents: apple官方格式离线文档

#更多说明详见iBT_Indoor_iOS_SDK.doc
