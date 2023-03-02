//
//  SampleHandler.swift
//  Example_ScreenSharing_Extension
//
//  Created by Meherdeep Thakur on 03/02/23.
//

import ReplayKit
import AgoraBroadcastExtensionHelper

class SampleHandler: AgoraBroadcastSampleHandler {
    override func getBroadcastData() -> AgoraBroadcastExtData? {
        return AgoraBroadcastExtData(
            appId: "<#Agora App ID#>",
            channel: "<#Channel Name#>",
            token: <#Token or nil#>,
            uid: 0
        )
    }
}
