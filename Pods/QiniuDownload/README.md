
## iOS下载SDK介绍

本SDK用于获取从iOS下载性能统计。

### 原理：

SDK提供了和`AFNetworking`一样的创建downloadTask的函数，封装了`NSURLSessionDownloadTask`， 
也就是说在在使用SDK的时候只需要把原来创建`NSURLSessionDownloadTask`的地方修改成从这个SDK创建出一个对应的task就可以，具体的函数见下面的使用

客户通过SDK下载的时候，会在SDK内部的各个地方获取本次下载相关的数据（不包含于用户或者app相关的任何隐私数据），丢到一个数组里面。
SDK内部会定时触发一个push操作，把搜集到的数据通过gzip压缩发送到服务器。之后用户可以通过七牛提供的查询页面查询自己的下载统计，或者设置监控。

### 统计分类

- 下载域名
- 地区分类（省，市）
- DNS查询时间
- DNS查询是否匹配到对应的CDN节点
- 服务端响应时间
- 服务端下载时间

### 额外流量：

单个统计发送的数据量有300Byte左右，经过gzip压缩200Byte左右。
客户端会把几次请求合并发送，经过gzip压缩之后平均每个统计100Byte左右，10k的数据量就可以发送100个统计点。
可以认为对手机端的流量影响较小。
如果认为这个数据量过多的话，也可以在SDK内部调节上传的比例（随机丢掉某些数据点）和发送数据点的间隔。

### 使用：

```
platform :ios, '7.0'
pod "QiniuDownload", "~> 1.0"
```

使用例子：

```
#import "QiniuDownload.h"

        QNDownloadManager *manager = [[QNDownloadManager alloc] init];
        NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];

        QNDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"File downloaded to: %@", filePath);
        }];
        [downloadTask resume];

```

### QNDownloadManager

新建`QNDownloadManager`类，通过它创建 `QNDownloadTask` 任务：

```
- (QNDownloadTask *) downloadTaskWithRequest:(NSURLRequest *)request
                                    progress:(NSProgress *)progress
                                 destination:(NSURL * (^__strong)(NSURL *__strong, NSURLResponse *__strong))destination
                           completionHandler:(void (^__strong)(NSURLResponse *__strong, NSURL *__strong, NSError *__strong))completionHandler;
```

其中：

- `request`: 请求
- `progress`: 下载的进度，可以为nil
- `destination`: 假如需要永久存储的话，在这个回调函数里面返回结果希望存的地址
- `completionHandler`: 完成后的回调函数

### QNDownloadTask

```
- (void) cancel;   //  取消本次的文件下载
- (void) resume;   //  开始文件下载
- (void) suspend;  //  暂停本次文件下载
```
