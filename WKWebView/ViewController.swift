//
//  ViewController.swift
//  WKWebView
//
//  Created by 廖佩志 on 2019/4/8.
//  Copyright © 2019 廖佩志. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {


    var wkWebView: WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = WKWebViewConfiguration()
        wkWebView = WKWebView(frame: view.frame, configuration: config)
//        let request = URLRequest(url: URL(string: "https://m.benlai.com/huanan/zt/1231cherry")!)
//        wkWebView?.load(request)
        let filePath = Bundle.main.path(forResource: "index", ofType: "html")
        let htmlString = try! String(contentsOfFile: filePath!, encoding: .utf8)
        wkWebView?.loadHTMLString(htmlString, baseURL: nil)

        view.addSubview(wkWebView!)
        wkWebView?.navigationDelegate = self
        wkWebView?.uiDelegate = self

        let userCC = config.userContentController
        userCC.add(self, name: "nativeMethod")
    }
    // 在页面加载完成时，注入JS代码,要不然还没加载完时就可以点击了,就不能调用我们的代码了!
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let path = Bundle.main.path(forResource: "data.txt", ofType: nil)
        let str = try? String(contentsOfFile: path!, encoding: .utf8)
        wkWebView?.evaluateJavaScript(str ?? "", completionHandler: { (response, error) in
//            print(response, error)
        })
    }
    //log(&quot;product&quot;, &quot;initcarturl_oversea&quot;, &quot;4343838&quot;)
    // 接收JS端发过来的消息，并处理相应的业务逻辑，此处不加入购物车，直接弹出产品ID即可
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "nativeMethod" {
            switch message.body as! String
            {
            case "openCamera":
                print("打开相机")
                show(meassge: "openCamera")
            default:
                print("未知操作")
            }
        }
    }
    //此方法作为js的alert方法接口的实现，默认弹出窗口应该只有提示信息及一个确认按钮，当然可以添加更多按钮以及其他内容，但是并不会起到什么作用
    //点击确认按钮的相应事件需要执行completionHandler，这样js才能继续执行
    ////参数 message为  js 方法 alert(<message>) 中的<message>
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
        show(meassge: message)

    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
        show(meassge: message)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        completionHandler("")
        show(meassge: defaultText ?? "")
    }
    
    /// alert
    func show(meassge: String) {
        let alertVC = UIAlertController(title: "功能描述", message: meassge, preferredStyle: .alert)
        let sure = UIAlertAction(title: "确认", style: .cancel, handler: nil)
        alertVC.addAction(sure)
        self.present(alertVC, animated: true, completion: nil)
    }

}

