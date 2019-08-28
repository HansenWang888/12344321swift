//
//  IMChatVC.swift
//  TencentIM
//
//  Created by hansen on 2019/4/29.
//  Copyright © 2019 hansen. All rights reserved.
//

import UIKit

import IQKeyboardManagerSwift
import JXPhotoBrowser

class IMChatVC: UIViewController, TChatControllerDelegate {
    
    
    var conversationData: TConversationCellData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatVC.delegate = self
        self.chatVC.conversation = self.conversationData
        self.addChild(self.chatVC)
        self.view.addSubview(self.chatVC.view)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "···", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBarBtnClick));
        // Do any additional setup after loading the view.
    }
    
    @objc private func rightBarBtnClick () {
        
        if conversationData?.convType == TConvType.type_Group {
            let vc = GroupDetailVC.init();
            vc.garoupId = self.conversationData?.convId;
            self.navigationController?.pushViewController(vc, animated: true);
        } else {
            let vc = MyInfoVC.init();
            vc.userid = Int(conversationData!.convId)!;
            self.navigationController?.pushViewController(vc, animated: true);
        }
        
        
    }
    
    private lazy var chatVC: TChatController = {
        let vc = TChatController()
        
        return vc
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    //MARK: TChatControllerDelegate
    func chatControllerDidClickRightBarButton(_ controller: TChatController!) {
//        debugPrint("chatControllerDidClickRightBarButton")
    }
    
    func chatController(_ chatController: TChatController!, didSelectMoreAt index: Int) {
//        debugPrint("didSelectMoreAt")
        switch index {
        case 0:
            //相册
            let vc = TZImagePickerController.init();
            vc.maxImagesCount = 5;
            vc.pickerDelegate = self;
            self.present(vc, animated: true, completion: nil);
            break;
        case 1:
            //拍摄
            break;
        case 2:
            //视频
            break;
        case 3:
            //文件
            
            break;
            
        default:
            break;
        }

    }
    
    func chatController(_ chatController: TChatController!, didSelectMessages msgs: NSMutableArray!, at index: Int) {
        if msgs[index] is TImageMessageCellData {
            
            let model = msgs[index] as! TImageMessageCellData;
            
            // 数据源
            let dataSource = JXLocalDataSource(numberOfItems: {
                // 共有多少项
                return 1;
            }, localImage: { index -> UIImage? in
                // 每一项的图片对象
                return model.thumbImage;
            });
            
            // 打开浏览器
            JXPhotoBrowser(dataSource: dataSource).show(pageIndex: index)
        }
        
    }
    
    func chatController(_ controller: TChatController!, didSelectedAvatar data: TMessageCellData!) {
        
        if data.sender.count > 0 {
            
            let vc = MyInfoVC.init();
            vc.userid = Int(data.sender);
            self.navigationController?.pushViewController(vc, animated: true);
        }
        
        
    }

}


extension IMChatVC: TZImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        if isSelectOriginalPhoto {
            
            for item in assets as! [PHAsset] {
                TZImageManager.default().getOriginalPhoto(with: item) { (image, hashDict) in
                    self.chatVC.sendImageMessage(image);
                }
            }

        } else {
            for item in photos {
                self.chatVC.sendImageMessage(item);
            }
            
        }
    }
    
    
}
