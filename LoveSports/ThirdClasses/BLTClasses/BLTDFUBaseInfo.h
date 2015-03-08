//
//  BLTDFUBaseInfo.h
//  ZKKBLT_OTA
//
//  Created by zorro on 15/2/15.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadEntity.h"

/**
 进行空中升级的时候的各种状态。
 */

#define DFUCONTROLLER_MAX_PACKET_SIZE   (20)
#define DFUCONTROLLER_DESIRED_NOTIFICATION_STEPS   (20)

typedef enum
{
    INIT,
    DISCOVERING,
    IDLE,
    SEND_NOTIFICATION_REQUEST,
    SEND_START_COMMAND,
    SEND_RECEIVE_COMMAND,
    SEND_FIRMWARE_DATA,
    SEND_VALIDATE_COMMAND,
    SEND_RESET,
    WAIT_RECEIPT,
    FINISHED,
    CANCELED,
} DFUControllerState;

typedef enum
{
    START_DFU = 1,
    INITIALIZE_DFU_PARAMS,
    RECEIVE_FIRMWARE_IMAGE,
    VALIDATE_FIRMWARE,
    ACTIVATE_RESET,
    RESET,
    REPORT_SIZE,
    REQUEST_RECEIPT,
    RESPONSE_CODE = 0x10,
    RECEIPT,
} DFUTargetOpcode;

typedef enum
{
    SUCCESS = 0x01,
    INVALID_STATE,
    NOT_SUPPORTED,
    DATA_SIZE_EXCEEDS_LIMIT,
    CRC_ERROR,
    OPERATION_FAILED,
} DFUTargetResponse;

typedef struct __attribute__((packed))
{
    uint8_t opcode;
    union
    {
        uint16_t n_packets;
        struct __attribute__((packed))
        {
            uint8_t   original;
            uint8_t   response;
        };
        uint32_t n_bytes;
    };
} dfu_control_point_data_t;

@interface BLTDFUBaseInfo : NSObject

@property (nonatomic, assign) NSInteger zipVersion;

AS_SINGLETON(BLTDFUBaseInfo)

+ (NSData *)getUpdateFirmWareData;

@end
