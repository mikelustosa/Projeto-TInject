//Version_JS;Version_TInjectMin;Version_CEF4Min;
//1.0.8.0;1.0.0.9;78.3.0
//
//

function getAllGroupContacts(Contacts) {
	SetConsoleMessage("GetAllGroupContacts", JSON.stringify(Contacts));	
}

function getMyNumber() {
    SetConsoleMessage('getMyNumber', localStorage.getItem('last-wid'));
    return true;
}


function convertImgToBase64URL(url, callback, outputFormat){
	var img = new Image();
    img.crossOrigin = 'Anonymous';
    img.onload = function(){
        var canvas = document.createElement('CANVAS'),
        ctx = canvas.getContext('2d'), dataURL;
        canvas.height = img.height;
        canvas.width = img.width;
        ctx.drawImage(img, 0, 0);
        dataURL = canvas.toDataURL(outputFormat);
        callback(dataURL);
        canvas = null; 
    };
    img.src = url;
};

function SetConsoleMessage(jsName, resultValue) {
    Obj = {
        name: jsName,
        result: '{"result":' + resultValue + '}'
    }
    console.log(JSON.stringify(Obj));
}

var intervalMonitor;
var isLoggedStatus = false;
var gettingUnreadMessages = false;

function startMonitor(intervalSeconds = 0) {
    isLoggedStatus = WAPI.isLoggedIn();
	
    if (intervalSeconds >= 1) {
        intervalMonitor = window.setInterval(monitorUnReadMessages, intervalSeconds * 1000);
    }
}

function stopMonitor() {
    window.clearInterval(intervalMonitor)
}

function removeElementsByClass(elementClass) {
    var elements = document.getElementsByClassName(elementClass);
    if (typeof elements !== 'undefined' && elements.length > 0) {
        for (var i = 0; i < elements.length; i++) {
            elements[i].parentNode.removeChild(elements[i]);
        }
    }
}

function moveElementsToParentParentElement(elementClass) {
    var elements = document.getElementsByClassName(elementClass);
    if (typeof elements !== 'undefined' && elements.length > 0) {
        for (var i = 0; i < elements.length; i++) {
            var element = elements[i];
            element.parentNode.parentNode.appendChild(element);
        }
    }
}

function monitorUnReadMessages() {
    if (gettingUnreadMessages) return;
    
    gettingUnreadMessages = true;
    
    var currentStatus = WAPI.isLoggedIn();
    if (currentStatus != isLoggedStatus) {
        isLoggedStatus = WAPI.isLoggedIn();
        SetConsoleMessage("OnChangeConnect", JSON.stringify(isLoggedStatus));
    }

    if (isLoggedStatus) {
        WAPI.getUnreadMessages(includeMe = "true", includeNotifications = "true", use_unread_count = "true");
    }
    gettingUnreadMessages = false;
}

if (!window.Store||!window.Store.Msg) {
    (function () {
        function getStore(modules) {
            let foundCount = 0;
            let neededObjects = [
                { id: "Store", conditions: (module) => (module.default && module.default.Chat && module.default.Msg) ? module.default : null},
  				{ id: "Conn", conditions: (module) => (module.default && module.default.ref && module.default.refTTL) ? module.default : (module.Conn ? module.Conn : null)},
                { id: "MediaCollection", conditions: (module) => (module.default && module.default.prototype && (module.default.prototype.processFiles !== undefined||module.default.prototype.processAttachments !== undefined)) ? module.default : null },
                { id: "MediaProcess", conditions: (module) => (module.BLOB) ? module : null },
                { id: "Archive", conditions: (module) => (module.setArchive) ? module : null },
                { id: "Block", conditions: (module) => (module.blockContact && module.unblockContact) ? module : null },
                { id: "ChatUtil", conditions: (module) => (module.sendClear) ? module : null },
				{ id: "GroupInvite", conditions: (module) => (module.sendQueryGroupInviteCode ) ? module : null },
                { id: "Wap", conditions: (module) => (module.createGroup) ? module : null },
                { id: "ServiceWorker", conditions: (module) => (module.default && module.default.killServiceWorker) ? module : null },
                { id: "State", conditions: (module) => (module.STATE && module.STREAM) ? module : null },
                { id: "_Presence", conditions: (module) => (module.setPresenceAvailable && module.setPresenceUnavailable) ? module : null },
                { id: "WapDelete", conditions: (module) => (module.sendConversationDelete && module.sendConversationDelete.length == 2) ? module : null },
                { id: 'FindChat', conditions: (module) => (module && module.findChat) ? module : null},				
				{ id: "WapQuery", conditions: (module) => (module.default && module.default.queryExist) ? module.default : null },				
                { id: 'Perfil', conditions: (module) => module.__esModule === true && module.setPushname && !module.getComposeContents ? module : null},
				{ id: "CryptoLib", conditions: (module) => (module.decryptE2EMedia) ? module : null },
                { id: "OpenChat", conditions: (module) => (module.default && module.default.prototype && module.default.prototype.openChat) ? module.default : null },
                { id: "UserConstructor", conditions: (module) => (module.default && module.default.prototype && module.default.prototype.isServer && module.default.prototype.isUser) ? module.default : null },
                { id: "SendTextMsgToChat", conditions: (module) => (module.sendTextMsgToChat) ? module.sendTextMsgToChat : null },
                { id: "ReadSeen", conditions: (module) => (module.sendSeen) ? module : null },
                { id: "sendDelete", conditions: (module) => (module.sendDelete) ? module.sendDelete : null },
                { id: "addAndSendMsgToChat", conditions: (module) => (module.addAndSendMsgToChat) ? module.addAndSendMsgToChat : null },
                { id: "sendMsgToChat", conditions: (module) => (module.sendMsgToChat) ? module.sendMsgToChat : null },
                { id: "Catalog", conditions: (module) => (module.Catalog) ? module.Catalog : null },
                { id: "bp", conditions: (module) => (module.default&&module.default.toString&&module.default.toString().includes('bp_unknown_version')) ? module.default : null },
                { id: "MsgKey", conditions: (module) => (module.default&&module.default.toString&&module.default.toString().includes('MsgKey error: obj is null/undefined')) ? module.default : null },
                { id: "Parser", conditions: (module) => (module.convertToTextWithoutSpecialEmojis) ? module.default : null },
                { id: "Builders", conditions: (module) => (module.TemplateMessage && module.HydratedFourRowTemplate) ? module : null },
                { id: "Me", conditions: (module) => (module.PLATFORMS && module.Conn) ? module.default : null },
                { id: "CallUtils", conditions: (module) => (module.sendCallEnd && module.parseCall) ? module : null },
                { id: "Identity", conditions: (module) => (module.queryIdentity && module.updateIdentity) ? module : null },
                { id: "MyStatus", conditions: (module) => (module.getStatus && module.setMyStatus) ? module : null },                
				{ id: "ChatStates", conditions: (module) => (module.sendChatStatePaused && module.sendChatStateRecording && module.sendChatStateComposing) ? module : null },				
                { id: "GroupActions", conditions: (module) => (module.sendExitGroup && module.localExitGroup) ? module : null },
                { id: "Features", conditions: (module) => (module.FEATURE_CHANGE_EVENT && module.features) ? module : null },
                { id: "MessageUtils", conditions: (module) => (module.storeMessages && module.appendMessage) ? module : null },
                { id: "WebMessageInfo", conditions: (module) => (module.WebMessageInfo && module.WebFeatures) ? module.WebMessageInfo : null },
                { id: "createMessageKey", conditions: (module) => (module.createMessageKey && module.createDeviceSentMessage) ? module.createMessageKey : null },
                { id: "Participants", conditions: (module) => (module.addParticipants && module.removeParticipants && module.promoteParticipants && module.demoteParticipants) ? module : null },
                { id: "WidFactory", conditions: (module) => (module.isWidlike && module.createWid && module.createWidFromWidLike) ? module : null },
                { id: "Base", conditions: (module) => (module.setSubProtocol && module.binSend && module.actionNode) ? module : null },
   				{ id: "Versions", conditions: (module) => (module.loadProtoVersions && module.default && module.default["15"] && module.default["16"] && module.default["17"]) ? module : null },
		        { id: "Sticker", conditions: (module) => (module.default && module.default.Sticker) ? module.default.Sticker : null },
                { id: "MediaUpload", conditions: (module) => (module.default && module.default.mediaUpload) ? module.default : null },
                { id: "UploadUtils", conditions: (module) => (module.default && module.default.encryptAndUpload) ? module.default : null },
				{ id: 'UserPrefs', conditions: (module) => (module.getMaybeMeUser ? module : null), },
                { id: 'Vcard', conditions: (module) => (module.vcardFromContactModel ? module : null)}
            ];
            for (let idx in modules) {
            	if ((typeof modules[idx] === "object") && (modules[idx] !== null)) {
                    neededObjects.forEach((needObj) => {
                    	if (!needObj.conditions || needObj.foundedModule)
                            return;
                    	let neededModule = needObj.conditions(modules[idx]);
                    	if (neededModule !== null) {
                            foundCount++;
                            needObj.foundedModule = neededModule;
                    	}
		    });

                    if (foundCount == neededObjects.length) {
                    	break;
                    }
            	}
            }
	    let neededStore = neededObjects.find((needObj) => needObj.id === "Store");
            window.Store = neededStore.foundedModule ? neededStore.foundedModule : {};
            neededObjects.splice(neededObjects.indexOf(neededStore), 1);
            neededObjects.forEach((needObj) => {
                if (needObj.foundedModule) {
                    window.Store[needObj.id] = needObj.foundedModule;
                }
            });
	    window.Store.Chat.modelClass.prototype.sendMessage = function (e) {
		window.Store.SendTextMsgToChat(this, ...arguments);
	    }
            return window.Store;
    	}
        const parasite = `parasite${Date.now()}`

        if (typeof webpackJsonp === 'function') webpackJsonp([], {[parasite]: (x, y, z) => getStore(z)}, [parasite]); 
		else webpackChunkwhatsapp_web_client.push([[parasite], {}, function (o, e, t) {let modules = []; for (let idx in o.m) {modules.push(o(idx));}	getStore(modules);}]);
        
    })();
}
 
window.WAPI = {};
window._WAPI = {};

window.WAPI._serializeRawObj = (obj) => {
    if (obj && obj.toJSON) {
        return obj.toJSON();
    }
    return {}
};

/**
 * Serializes a chat object
 *
 * @param rawChat Chat object
 * @returns {{}}
 */

window.WAPI._serializeChatObj = (obj) => {
    if (obj == undefined) {
        return null;
    }
    return Object.assign(window.WAPI._serializeRawObj(obj), {
        kind: obj.kind,
        isGroup: obj.isGroup,
        formattedTitle: obj.formattedTitle,
        contact: obj['contact'] ? window.WAPI._serializeContactObj(obj['contact']) : null,
        groupMetadata: obj["groupMetadata"] ? window.WAPI._serializeRawObj(obj["groupMetadata"]) : null,
        presence: obj["presence"] ? window.WAPI._serializeRawObj(obj["presence"]) : null,
        msgs: null
    });
};

window.WAPI._serializeContactObj = (obj) => {
    if (obj == undefined) {
        return null;
    }
	
	let profilePhoto = window.Store.ProfilePicThumb._index[obj.__x_id._serialized] ? window.Store.ProfilePicThumb._index[obj.__x_id._serialized].__x_imgFull : {}
	
    return Object.assign(window.WAPI._serializeRawObj(obj), {
		id: obj.id._serialized,
        formattedName: obj.formattedName,
        isHighLevelVerified: obj.isHighLevelVerified,
        isMe: obj.isMe,
        isMyContact: obj.isMyContact,
        isPSA: obj.isPSA,
        isUser: obj.isUser,
        isVerified: obj.isVerified,
        isWAContact: obj.isWAContact,
        profilePicThumb: profilePhoto,
		statusMute: obj.statusMute,
        msgs: null
    });
};

window.WAPI._serializeMessageObj = (obj) => {
    if (obj == undefined) {
        return null;
    }
    const _chat = obj['chat'] ? WAPI._serializeChatObj(obj['chat']) : {};
    if(obj.quotedMsg) obj.quotedMsgObj();
    return Object.assign(window.WAPI._serializeRawObj(obj), {
        id: obj.id._serialized,
        //add 02/06/2020 mike -->
		quotedParticipant: obj.quotedParticipant? obj.quotedParticipant._serialized ? obj.quotedParticipant._serialized : undefined : undefined,
        author: obj.author? obj.author._serialized ? obj.author._serialized : undefined : undefined,
        chatId: obj.chatId? obj.chatId._serialized ? obj.chatId._serialized : undefined : undefined,
        to: obj.to? obj.to._serialized ? obj.to._serialized : undefined : undefined,
        fromMe: obj.id.fromMe,
		//add 02/06/2020 mike <--
		
		sender: obj["senderObj"] ? WAPI._serializeContactObj(obj["senderObj"]) : null,
        timestamp: obj["t"],
        content: obj["body"],
        isGroupMsg: obj.isGroupMsg,
        isLink: obj.isLink,
        isMMS: obj.isMMS,
        isMedia: obj.isMedia,
        isNotification: obj.isNotification,
        isPSA: obj.isPSA,
        type: obj.type,
        chat: _chat,
        isOnline: _chat.isOnline,
        lastSeen: _chat.lastSeen,
        chatId: obj.id.remote,
        quotedMsgObj: WAPI._serializeMessageObj(obj['_quotedMsgObj']),
        mediaData: window.WAPI._serializeRawObj(obj['mediaData']),
        reply: body => window.WAPI.reply(_chat.id._serialized, body, obj)
    });
};

window.WAPI._serializeNumberStatusObj = (obj) => {
    if (obj == undefined) {
        return null;
    }

    return Object.assign({}, {
        id: obj.jid,
        status: obj.status,
        isBusiness: (obj.biz === true),
        canReceiveMessage: (obj.status === 200)
    });
};

window.WAPI._serializeProfilePicThumb = (obj) => {
    if (obj == undefined) {
        return null;
    }

    return Object.assign({}, {
        eurl: obj.eurl,
        id: obj.id,
        img: obj.img,
        //imgFull: obj.imgFull,
		imgFull: obj.__x_imgFull,
        raw: obj.raw,
        tag: obj.tag
    });
}

window.WAPI.createGroup = async function (name, contactsId) {
    if (!Array.isArray(contactsId)) {
        contactsId = [contactsId];
    }

    return await window.Store.WapQuery.createGroup(name, contactsId);;
};

window.WAPI.leaveGroup = function(groupId) {
    groupId = typeof groupId == "string" ? groupId : groupId._serialized;
    var group = WAPI.getChat(groupId);
    return Store.GroupActions.sendExitGroup(group)
};


window.WAPI.getAllContacts = function(done) {
    const contacts = window.Store.Contact.map((contact) => WAPI._serializeContactObj(contact));

    if (done !== undefined) done(contacts);

    SetConsoleMessage("getAllContacts", JSON.stringify(contacts));

    return contacts;
};

/**
 * Fetches all contact objects from store, filters them
 *
 * @param done Optional callback function for async execution
 * @returns {Array|*} List of contacts
 */
window.WAPI.getMyContacts = function(done) {
    const contacts = window.Store.Contact.filter((contact) => contact.isMyContact === true).map((contact) => WAPI._serializeContactObj(contact));
    if (done !== undefined) done(contacts);
    return contacts;
};

/**
 * Fetches contact object from store by ID
 *
 * @param id ID of contact
 * @param done Optional callback function for async execution
 * @returns {T|*} Contact object
 */
window.WAPI.getContact = function(id, done) {
    const found = window.Store.Contact.get(id);

    if (done !== undefined) done(window.WAPI._serializeContactObj(found))
    return window.WAPI._serializeContactObj(found);
};

/**
 * Fetches all chat objects from store
 *
 * @param done Optional callback function for async execution
 * @returns {Array|*} List of chats
 */
window.WAPI.getAllChats = function(done) {
    const chats = window.Store.Chat.map((chat) => WAPI._serializeChatObj(chat));

    if (done !== undefined) done(chats);

    SetConsoleMessage("getAllChats", JSON.stringify(chats));

    return chats;
};

window.WAPI.haveNewMsg = function(chat) {
    return chat.unreadCount > 0;
};

window.WAPI.getAllChatsWithNewMsg = function(done) {
    const chats = window.Store.Chat.filter(window.WAPI.haveNewMsg).map((chat) => WAPI._serializeChatObj(chat));

    if (done !== undefined) done(chats);
    return chats;
};

/**
 * Fetches all chat IDs from store
 *
 * @param done Optional callback function for async execution
 * @returns {Array|*} List of chat id's
 */
window.WAPI.getAllChatIds = function(done) {
    const chatIds = window.Store.Chat.map((chat) => chat.id._serialized || chat.id);

    if (done !== undefined) done(chatIds);
    return chatIds;
};

window.WAPI.getAllNewMessages = async function () {
    return JSON.stringify(WAPI.getAllChatsWithNewMsg().map(c => WAPI.getChat(c.id._serialized)).map(c => c.msgs._models.filter(x => x.isNewMsg)) || [])
}


/**
 * Fetches all groups objects from store
 *
 * @param done Optional callback function for async execution
 * @returns {Array|*} List of chats
 */
 
 
window.WAPI.getAllGroups = function(done) {
    let groups = window.Store.Chat.filter((chat) => chat.isGroup);

	if (done !== undefined) done(groups);
	

	let arrGroups = [];
	let arr = groups;
	arr.forEach((v , i) => {
		arrGroups.push(arr[i]['id']['_serialized']+' '+arr[i]['formattedTitle']);
	})
	
	SetConsoleMessage("getAllGroups", JSON.stringify(arrGroups));
	
	//return groups;
}; 

//01/06/2020
window.WAPI.getAllGroupsList = function(done) {
    const contacts = window.Store.Contact.map((contact) => WAPI._serializeContactObj(contact));

    if (done !== undefined) done(contacts);

    SetConsoleMessage("getAllGroups", JSON.stringify(contacts));

    return contacts;
};

/**
 * Sets the chat state
 * 
 * @param {0|1|2} chatState The state you want to set for the chat. Can be TYPING (1), RECRDING (2) or PAUSED (3);
 * returns {boolean}
 */
window.WAPI.sendChatstate = async function (state, chatId) {

   switch(state) {
        
			case 0:
				
					await window.Store.ChatStates.sendChatStateComposing(chatId);
					break;

			case 1:

					await window.Store.ChatStates.sendChatStateRecording(chatId);
					break;

			case 2:

					await window.Store.ChatStates.sendChatStatePaused(chatId);
					break;
				
			default:
			
				return false

    }
    return true;

};

/**
 * Fetches chat object from store by ID
 *
 * @param id ID of chat
 * @returns {T|*} Chat object
 */
window.WAPI.getChat = function (id) {
    id = typeof id == "string" ? id : id._serialized;
    const found = window.Store.Chat.get(id);
    if (found) found.sendMessage = (found.sendMessage) ? found.sendMessage : function () { return window.Store.sendMessage.apply(this, arguments); };
    return found;
}

window.WAPI.getChatByName = function(name, done) {
    const found = window.Store.FindChat.findChat((chat) => chat.name === name);
    if (done !== undefined) done(found);
    return found;
};

window.WAPI.sendImageFromDatabasePicBot = function (picId, chatId, caption) {
    var chatDatabase = window.WAPI.getChatByName('DATABASEPICBOT');
    var msgWithImg = chatDatabase.msgs.find((msg) => msg.caption == picId);

    if (msgWithImg === undefined) {
        return false;
    }
    var chatSend = WAPI.getChat(chatId);
    if (chatSend === undefined) {
        return false;
    }
    const oldCaption = msgWithImg.caption;

    msgWithImg.id.id = window.WAPI.getNewId();
    msgWithImg.id.remote = chatId;
    msgWithImg.t = Math.ceil(new Date().getTime() / 1000);
    msgWithImg.to = chatId;

    if (caption !== undefined && caption !== '') {
        msgWithImg.caption = caption;
    } else {
        msgWithImg.caption = '';
    }

    msgWithImg.collection.send(msgWithImg).then(function (e) {
        msgWithImg.caption = oldCaption;
    });

    return true;
};

window.WAPI.getGeneratedUserAgent = function (useragent) {
    if (!useragent.includes('WhatsApp')) return 'WhatsApp/0.4.315 ' + useragent;
    return useragent.replace(useragent.match(/WhatsApp\/([.\d])*/g)[0].match(/[.\d]*/g).find(x => x), window.Debug.VERSION)
}

window.WAPI.getWAVersion = function () {
    return window.Debug.VERSION;
}

/**
 * Automatically sends a link with the auto generated link preview. You can also add a custom message to be added.
 * @param chatId 
 * @param url string A link, for example for youtube. e.g https://www.youtube.com/watch?v=61O-Galzc5M
 * @param text string Custom text as body of the message, this needs to include the link or it will be appended after the link.
 */
window.WAPI.sendLinkWithAutoPreview = async function (chatId, url, text) { 
    var idUser = new window.Store.UserConstructor(chatId, {
        intentionallyUsePrivateConstructor: true
    });


	const fromwWid = await window.Store.Conn.wid;

	const linkPreview =  await Store.WapQuery.queryLinkPreview(url)

    let queue = await Store.Contact.get(chatId);
    const contact = await Store.FindChat.findChat(idUser)
    const newChat = await Object.assign(queue, contact);

    
    var newId = window.WAPI.getNewMessageId(chatId);

    var message =  {
		id: newId,
        ack: 0,
        body: `${url}\n${text}`,
        //from: fromwWid._serialized, //MD
		from: fromwWid,
        to: contact.id,
        local: !0,
        self: 'out',
        t: parseInt(new Date().getTime() / 1000),
        isNewMsg: !0,
        type: 'chat',
        subtype: 'url',
        canonicalUrl: linkPreview.canonicalUrl,
        description: linkPreview.description,
        doNotPlayInline: linkPreview.doNotPlayInline,
        matchedText: linkPreview.matchedText,
        preview: linkPreview.preview,
        thumbnail: linkPreview.thumbnail,
        title: linkPreview.title
	};

      return await Promise.all(Store.addAndSendMsgToChat(newChat, message))
}

window.WAPI.sendMessageWithThumb = function (thumb, url, title, description, text, chatId) {
    var chatSend = WAPI.getChat(chatId);
    if (chatSend === undefined) {
        return false;
    }
    var linkPreview = {
        canonicalUrl: url,
        description: description,
        matchedText: url,
        title: title,
        thumbnail: thumb // Thumbnail max size allowed: 200x200
    };
    chatSend.sendMessage(text.includes(url) ? text : `${url}\n${text}`, { linkPreview: linkPreview, mentionedJidList: [], quotedMsg: null, quotedMsgAdminGroupJid: null });
    return true;
};


window.WAPI.getNewId = function() {
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for (var i = 0; i < 20; i++)
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    return text;
};

window.WAPI.getChatById = function(id, done) {
    let found = WAPI.getChat(id);
    if (found) {
        found = WAPI._serializeChatObj(found);
    } else {
        found = false;
    }

    if (done !== undefined) done(found);
    return found;
};

/**
 * Retorno todas as mensagens nao lidas de um bate-papo solicitado e as marca como lidas.
 *
 * :param id: chat id
 * :type id: string
 *
 * :param includeMe: indicates if user messages have to be included
 * :type includeMe: boolean
 *
 * :param includeNotifications: indicates if notifications have to be included
 * :type includeNotifications: boolean
 *
 * :param done: callback passed by selenium
 * :type done: function
 *
 * :returns: list of unread messages from asked chat
 * :rtype: object
 */
window.WAPI.getUnreadMessagesInChat = function(id, includeMe, includeNotifications, done) {
    // get chat and its messages
    let chat = WAPI.getChat(id);
    let messages = chat.msgs._models;

    // initialize result list
    let output = [];

    // look for unread messages, newest is at the end of array
    for (let i = messages.length - 1; i >= 0; i--) {
        // system message: skip it
        if (i === "remove") {
            continue;
        }

        // get message
        let messageObj = messages[i];

        // found a read message: stop looking for others
        if (typeof(messageObj.isNewMsg) !== "boolean" || messageObj.isNewMsg === false) {
            continue;
        } else {
            messageObj.isNewMsg = false;
            // process it
            let message = WAPI.processMessageObj(messageObj,
                includeMe,
                includeNotifications);

            // save processed message on result list
            if (message)
                output.push(message);
        }
    }
    // callback was passed: run it
    if (done !== undefined) done(output);
    // return result list
    return output;
};

/**
 * Load more messages in chat object from store by ID
 *
 * @param id ID of chat
 * @param done Optional callback function for async execution
 * @returns None
 */
window.WAPI.loadEarlierMessages = function(id, done) {
    const found = WAPI.getChat(id);
    if (done !== undefined) {
        found.loadEarlierMsgs().then(function() {
            done()
        });
    } else {
        found.loadEarlierMsgs();
    }
};

/**
 * Load more messages in chat object from store by ID
 *
 * @param id ID of chat
 * @param done Optional callback function for async execution
 * @returns None
 */
window.WAPI.loadAllEarlierMessages = function(id, done) {
    const found = WAPI.getChat(id);
    x = function() {
        if (!found.msgs.msgLoadState.noEarlierMsgs) {
            found.loadEarlierMsgs().then(x);
        } else if (done) {
            done();
        }
    };
    x();
};

window.WAPI.asyncLoadAllEarlierMessages = function(id, done) {
    done();
    window.WAPI.loadAllEarlierMessages(id);
};

window.WAPI.areAllMessagesLoaded = function(id, done) {
    const found = WAPI.getChat(id);
    if (!found.msgs.msgLoadState.noEarlierMsgs) {
        if (done) done(false);
        return false
    }
    if (done) done(true);
    return true
};

/**
 * Load more messages in chat object from store by ID till a particular date
 *
 * @param id ID of chat
 * @param lastMessage UTC timestamp of last message to be loaded
 * @param done Optional callback function for async execution
 * @returns None
 */

window.WAPI.loadEarlierMessagesTillDate = function(id, lastMessage, done) {
    const found = WAPI.getChat(id);
    x = function() {
        if (found.msgs.models[0].t > lastMessage) {
            found.loadEarlierMsgs().then(x);
        } else {
            done();
        }
    };
    x();
};

/**
 * Fetches all group metadata objects from store
 *
 * @param done Optional callback function for async execution
 * @returns {Array|*} List of group metadata
 */
window.WAPI.getAllGroupMetadata = function(done) {
    const groupData = window.Store.GroupMetadata.map((groupData) => groupData.all);

    if (done !== undefined) done(groupData);
    return groupData;
};

/**
 * Fetches group metadata object from store by ID
 *
 * @param id ID of group
 * @param done Optional callback function for async execution
 * @returns {T|*} Group metadata object
 */
 
/* Deprecated 02/06/2020
window.WAPI.getGroupMetadata = async function(id, done) {
    let output = window.Store.GroupMetadata.get(id);

    if (output !== undefined) {
        if (output.stale) {
            await output.update();
        }
    }

    if (done !== undefined) done(output);
    return output;

}; */

window.WAPI.getGroupMetadata = async function (id) {
    return window.Store.GroupMetadata.find(id);
};

/**
 * Fetches group participants
 *
 * @param id ID of group
 * @returns {Promise.<*>} Yields group metadata
 * @private
 */
window.WAPI._getGroupParticipants = async function(id) {
    const metadata = await WAPI.getGroupMetadata(id);
    return metadata.participants;
};

/**
 * Fetches IDs of group participants
 *
 * @param id ID of group
 * @param done Optional callback function for async execution
 * @returns {Promise.<Array|*>} Yields list of IDs
 */

/*
window.WAPI.getGroupParticipantIDs = async function (id) {
    return (await WAPI._getGroupParticipants(id))
        .map((participant) => participant.id);
}; */


window.WAPI.getGroupParticipantIDs = async function(id, done) {
    const output = (await WAPI._getGroupParticipants(id))
        .map((participant) => participant.id);

    if (done !== undefined) done(output);
	getAllGroupContacts(JSON.stringify(output));
		   
	return output;
};

window.WAPI.getGroupAdmins = async function(id, done) {
    const output = (await WAPI._getGroupParticipants(id))
        .filter((participant) => participant.isAdmin)
        .map((admin) => admin.id);

    if (done !== undefined) done(output);
	let arrGroupAdm = [];
	let arr = output;
	arr.forEach((v , i) => {
		arrGroupAdm.push(arr[i]['_serialized']);
	})
	SetConsoleMessage("getAllGroupAdmins", JSON.stringify(arrGroupAdm));
	
    return output;
};

/**
 * Gets object representing the logged in user
 *
 * @returns {Array|*|$q.all}
 */
window.WAPI.getMe = function(done) {
    const rawMe = window.Store.Contact.get(window.Store.Conn.me);

    if (done !== undefined) done(rawMe.all);
    return rawMe.all;
};

window.WAPI.isLoggedIn = function(done) {
    // Contact always exists when logged in
    const isLogged = window.Store.Contact && window.Store.Contact.checksum !== undefined;

    if (done !== undefined) done(isLogged);
    return isLogged;
};

//Funcao para saber o status do servico - Mike 26/02/2020
window.WAPI.isConnected = function (done) {
    const isConnected = document.querySelector('*[data-icon="alert-phone"]') !== null ? false : true;

    if (done !== undefined) done(isConnected);
	SetConsoleMessage("GetCheckIsConnected", JSON.stringify(isConnected));
    return isConnected;
};

window.WAPI.teste = function (url) {
	var lUrl = window.Store.ProfilePicThumb._index[url].__x_imgFull;
	convertImgToBase64URL(lUrl, function(base64Img){
		SetConsoleMessage("GetProfilePicThumb", JSON.stringify(base64Img));
	});
};


window.WAPI.getProfilePicFromServer = function (id) {
	return Store.WapQuery.profilePicFind(id).then(x => console.log(x.eurl));
}

window.WAPI.getProfilePicSmallFromId = async function (id) {
    return await window.Store.ProfilePicThumb.find(id).then(async d=> {
        if (d.img !== undefined) {
            return await window.WAPI.downloadFileWithCredentials(d.img);
        } else {
            return false
        }
    }, function (e) {
        return false
    })
};


window.WAPI.processMessageObj = function(messageObj, includeMe, includeNotifications) {
    if (messageObj.isNotification) {
        if (includeNotifications)
            return WAPI._serializeMessageObj(messageObj);
        else
            return;
        // System message
        // (i.e. "Messages you send to this chat and calls are now secured with end-to-end encryption...")
    } else if (messageObj.id.fromMe === false || includeMe) {
        return WAPI._serializeMessageObj(messageObj);
    }

    SetConsoleMessage("processMessageObj", JSON.stringify(messageObj));
    return;
};

window.WAPI.getAllMessagesInChat = function(id, includeMe, includeNotifications, done) {
    const chat = WAPI.getChat(id);
    let output = [];
    const messages = chat.msgs._models;

    for (const i in messages) {
        if (i === "remove") {
            continue;
        }
        const messageObj = messages[i];

        //Miro Emidio - 05/Dez/2019 Alterado para funcionamento em WHATS empresarial/pessoal
        let message = WAPI.processMessageObj(messageObj, includeMe, false) //includeNotifications
        if (message)
            output.push(message);
    }
    if (done !== undefined) done(output);
    return output;
};

window.WAPI.getAllMessageIdsInChat = function(id, includeMe, includeNotifications, done) {
    const chat = WAPI.getChat(id);
    let output = [];
    const messages = chat.msgs._models;

    for (const i in messages) {
        if ((i === "remove") || (!includeMe && messages[i].isMe) || (!includeNotifications && messages[i].isNotification)) {
            continue;
        }
        output.push(messages[i].id._serialized);
    }
    if (done !== undefined) done(output);
    return output;
};

window.WAPI.getMessageById = function(id, done) {
    let result = false;
    try {
        let msg = window.Store.Msg.get(id);
        if (msg) {
            result = WAPI.processMessageObj(msg, true, true);
        }
    } catch (err) {}

    if (done !== undefined) {
        done(result);
    } else {
        return result;
    }
};

window.WAPI.ReplyMessage = function(idMessage, message, done) {
    var messageObject = window.Store.Msg.get(idMessage);
    if (messageObject === undefined) {
        if (done !== undefined) done(false);
        return false;
    }
    messageObject = messageObject.value();

    const chat = WAPI.getChat(messageObject.chat.id)
    if (chat !== undefined) {
        if (done !== undefined) {
            chat.sendMessage(message, null, messageObject).then(function() {
                function sleep(ms) {
                    return new Promise(resolve => setTimeout(resolve, ms));
                }

                var trials = 0;

                function check() {
                    for (let i = chat.msgs.models.length - 1; i >= 0; i--) {
                        let msg = chat.msgs.models[i];

                        if (!msg.senderObj.isMe || msg.body != message) {
                            continue;
                        }
                        done(WAPI._serializeMessageObj(msg));
                        return True;
                    }
                    trials += 1;
                    console.log(trials);
                    if (trials > 30) {
                        done(true);
                        return;
                    }
                    sleep(500).then(check);
                }
                check();
            });
            return true;
        } else {
            chat.sendMessage(message, null, messageObject);
            return true;
        }
    } else {
        if (done !== undefined) done(false);
        return false;
    }
};

//Funcao desativada em 27/11/2019 by Mike
/*window.WAPI.sendMessageToID = function (id, message, done) {
try {
window.getContact = (id) => {
return Store.WapQuery.queryExist(id);
}
window.getContact(id).then(contact => {
if (contact.status === 404) {
done(true);
} else {
Store.FindChat.findChat(contact.jid).then(chat => {
chat.sendMessage(message);
return true;
}).catch(reject => {
if (WAPI.sendMessage(id, message)) {
done(true);
return true;
}else{
done(false);
return false;
}
});
}
});
} catch (e) {
if (window.Store.Chat.length === 0)
return false;

firstChat = Store.Chat.models[0];
var originalID = firstChat.id;
firstChat.id = typeof originalID === "string" ? id : new window.Store.UserConstructor(id, { intentionallyUsePrivateConstructor: true });
if (done !== undefined) {
firstChat.sendMessage(message).then(function () {
firstChat.id = originalID;
done(true);
});
return true;
} else {
firstChat.sendMessage(message);
firstChat.id = originalID;
return true;
}
}
if (done !== undefined) done(false);
return false;
} */

window.WAPI.sendMessage = function(id, message, done) {
    var chat = WAPI.getChat(id);
    if (chat !== undefined) {
        if (done !== undefined) {
            chat.sendMessage(message).then(function() {
                function sleep(ms) {
                    return new Promise(resolve => setTimeout(resolve, ms));
                }

                var trials = 0;

                function check() {
                    for (let i = chat.msgs.models.length - 1; i >= 0; i--) {
                        let msg = chat.msgs.models[i];

                        if (!msg.senderObj.isMe || msg.body != message) {
                            continue;
                        }
                        done(WAPI._serializeMessageObj(msg));
                        return True;
                    }
                    trials += 1;
                    console.log(trials);
                    if (trials > 30) {
                        done(true);
                        return;
                    }
                    sleep(500).then(check);
                }
                check();
            });
            return true;
        } else {
            chat.sendMessage(message);
            return true;
        }
    } else {
        if (done !== undefined) done(false);
        return false;
    }
};

window.WAPI.sendMessage2 = function(id, message, done) {
    var chat = WAPI.getChat(id);
    if (chat !== undefined) {
        try {
            if (done !== undefined) {
                chat.sendMessage(message).then(function() {
                    done(true);
                });
            } else {
                chat.sendMessage(message);
            }
            return true;
        } catch (error) {
            if (done !== undefined) done(false)
            return false;
        }
    }
    if (done !== undefined) done(false)
    return false;
};

//Funcao adicionada em 18/06/2020 by Mike
window.WAPI.sendSeen = async function (id) {
    if (!id) return false;
    var chat = window.WAPI.getChat(id);
    if (chat !== undefined) {
            await Store.ReadSeen.sendSeen(chat, false);
            return true;
    }
    return false;
};

/*
//Apos receber uma mensagem, e nao responder, essa funcao nao funciona de forma isolada
window.WAPI.sendSeen = function(id, done) {
    var chat = window.WAPI.getChat(id);
    if (chat !== undefined) {
        if (done !== undefined) {
            Store.SendSeen(Store.Chat.models[0], false).then(function() {
                done(true);
            });
            return true;
        } else {
            Store.SendSeen(Store.Chat.models[0], false);
            return true;
        }
    }
    if (done !== undefined) done();
    return false;
}; */

/*
//Alterado em 20/02/2020 Creditos: by Lucas
//Apos receber uma mensagem, e nao responder, essa funcao funciona de forma isolada
window.WAPI.sendSeen = function(id, done) {
    var chat = window.WAPI.getChat(id);
    if (chat !== undefined) {
        if (done !== undefined) {
            Store.SendSeen(Store.Chat.models[0], false).then(function() {
                done(true);
            });
            return true;
        } else {
            Store.SendSeen(Store.Chat.models[0], false);
            return true;
        }
    }
    if (done !== undefined) done();
    return false;
}; */

function isChatMessage(message) {
    if (message.isSentByMe) {
        return false;
    }
    if (message.isNotification) {
        return false;
    }
    if (!message.isUserCreatedType) {
        return false;
    }
    return true;
}

window.WAPI.getUnreadMessages = function(includeMe, includeNotifications, use_unread_count, done) {
    const chats = window.Store.Chat.models;
    let output = [];

    for (let chat in chats) {
        if (isNaN(chat)) {
            continue;
        }

        let messageGroupObj = chats[chat];
        let messageGroup = WAPI._serializeChatObj(messageGroupObj);

        messageGroup.messages = [];

        const messages = messageGroupObj.msgs._models;
        for (let i = messages.length - 1; i >= 0; i--) {
            let messageObj = messages[i];
            if (typeof(messageObj.isNewMsg) != "boolean" || messageObj.isNewMsg === false) {
                continue;
            } else {
                messageObj.isNewMsg = false;
                //Miro Emidio - 05/Dez/2019 Alterado para funcionamento em WHATS empresarial/pessoal
                let message = WAPI.processMessageObj(messageObj, includeMe, false); //includeNotifications);// MUDAR PARA "FALSE" AQUI
                if (message) {
                    messageGroup.messages.push(message);
                }
            }
        }

        if (messageGroup.messages.length > 0) {
            output.push(messageGroup);
        } else { // no messages with isNewMsg true
            if (use_unread_count) {
                let n = messageGroupObj.unreadCount; // usara o atributo unreadCount para buscar as ultimas n mensagens do remetente
                for (let i = messages.length - 1; i >= 0; i--) {
                    let messageObj = messages[i];
                    if (n > 0) {
                        if (!messageObj.isSentByMe) {
                            let message = WAPI.processMessageObj(messageObj, includeMe, includeNotifications);
                            messageGroup.messages.unshift(message);
                            n -= 1;
                        }
                    } else if (n === -1) { // chat was marked as unread so will fetch last message as unread
                        if (!messageObj.isSentByMe) {
                            let message = WAPI.processMessageObj(messageObj, includeMe, includeNotifications);
                            messageGroup.messages.unshift(message);
                            break;
                        }
                    } else { // unreadCount = 0
                        break;
                    }
                }
                if (messageGroup.messages.length > 0) {
                    messageGroupObj.unreadCount = 0; // reset unread counter
                    output.push(messageGroup);
                }
            }
        }
    }
    if (done !== undefined) {
        done(output);

    }
	
	//mike teste 16/02/2021 tentativa de retornar imagem de perfil
    SetConsoleMessage("getUnreadMessages", JSON.stringify(output));
    return output;
};

window.WAPI.getGroupOwnerID = async function(id, done) {
    const output = (await WAPI.getGroupMetadata(id)).owner.id;
    if (done !== undefined) {
        done(output);
    }

    SetConsoleMessage("getGroupOwnerID", JSON.stringify(output));

    return output;

};

window.WAPI.getCommonGroups = async function(id, done) {
    let output = [];

    groups = window.WAPI.getAllGroups();

    for (let idx in groups) {
        try {
            participants = await window.WAPI.getGroupParticipantIDs(groups[idx].id);
            if (participants.filter((participant) => participant == id).length) {
                output.push(groups[idx]);
            }
        } catch (err) {
            console.log("Error in group:");
            console.log(groups[idx]);
            console.log(err);
        }
    }

    if (done !== undefined) {
        done(output);
    }
    return output;
};

window.WAPI.getProfilePicSmallFromId = function(id, done) {
    window.Store.ProfilePicThumb.find(id).then(function(d) {
        if (d.img !== undefined) {
            window.WAPI.downloadFileWithCredentials(d.img, done);
        } else {
            done(false);
        }
    }, function(e) {
        done(false);
    })
};

window.WAPI.getProfilePicFromId = function(id, done) {
    window.Store.ProfilePicThumb.find(id).then(function(d) {
        if (d.imgFull !== undefined) {
            window.WAPI.downloadFileWithCredentials(d.imgFull, done);
        } else {
            done(false);
        }
    }, function(e) {
        done(false);
    })
};

window.WAPI.downloadFileWithCredentials = function(url, done) {
    let xhr = new XMLHttpRequest();

    xhr.onload = function() {
        if (xhr.readyState == 4) {
            if (xhr.status == 200) {
                let reader = new FileReader();
                reader.readAsDataURL(xhr.response);
                reader.onload = function(e) {
                    done(reader.result.substr(reader.result.indexOf(',') + 1))
                };
            } else {
                console.error(xhr.statusText);
            }
        } else {
            console.log(err);
            done(false);
        }
    };

    xhr.open("GET", url, true);
    xhr.withCredentials = true;
    xhr.responseType = 'blob';
    xhr.send(null);
};

window.WAPI.downloadFile = function(url, done) {
    let xhr = new XMLHttpRequest();

    xhr.onload = function() {
        if (xhr.readyState == 4) {
            if (xhr.status == 200) {
                let reader = new FileReader();
                reader.readAsDataURL(xhr.response);
                reader.onload = function(e) {
                    done(reader.result.substr(reader.result.indexOf(',') + 1))
                };
            } else {
                console.error(xhr.statusText);
            }
        } else {
            console.log(err);
            done(false);
        }
    };

    xhr.open("GET", url, true);
    xhr.responseType = 'blob';
    xhr.send(null);
};

window.WAPI.getBatteryLevel = function(done) {
    if (window.Store.Conn.plugged) {
        if (done !== undefined) {
            done(100);
        }
        output = 100;
        return SetConsoleMessage("getBatteryLevel", JSON.stringify(output));
    }
    output = window.Store.Conn.battery;
    if (done !== undefined) {
        done(output);
    }
    SetConsoleMessage("getBatteryLevel", JSON.stringify(output));
    return output;
};

window.WAPI.deleteConversation = async function (chatId) {
    let userId = new window.Store.UserConstructor(chatId, { intentionallyUsePrivateConstructor: true });
    let conversation = WAPI.getChat(userId);
    if (!conversation) {
        return false;
    }
    return await window.Store.sendDelete(conversation, false).then(() => {
        return true;
    }).catch(() => {
        return false;
    });
};

window.WAPI.deleteMessage = function(chatId, messageArray, revoke = false, done) {
    let userId = new window.Store.UserConstructor(chatId, {
        intentionallyUsePrivateConstructor: true
    });
    let conversation = WAPI.getChat(userId);

    if (!conversation) {
        if (done !== undefined) {
            done(false);
        }
        return false;
    }

    if (!Array.isArray(messageArray)) {
        messageArray = [messageArray];
    }

    if (revoke) {
        conversation.sendRevokeMsgs(messageArray, conversation);
    } else {
        conversation.sendDeleteMsgs(messageArray, conversation);
    }

    if (done !== undefined) {
        done(true);
    }

    return true;
};

window.WAPI.checkNumberStatus = function(id, done) {
    window.Store.WapQuery.queryExist(id).then((result) => {
        if (done !== undefined) {
            if (result.jid === undefined) throw 404;
            done(window.WAPI._serializeNumberStatusObj(result));
        }
    }).catch((e) => {
        if (done !== undefined) {
            done(window.WAPI._serializeNumberStatusObj({
                status: e,
                jid: id
            }));
        }
    });

    return true;
};

/**
 * New messages observable functions.
 */
window.WAPI._newMessagesQueue = [];
window.WAPI._newMessagesBuffer = (sessionStorage.getItem('saved_msgs') != null) ? JSON.parse(sessionStorage.getItem('saved_msgs')) : [];
window.WAPI._newMessagesDebouncer = null;
window.WAPI._newMessagesCallbacks = [];

window.Store.Msg.off('add');
sessionStorage.removeItem('saved_msgs');

window.WAPI._newMessagesListener = window.Store.Msg.on('add', (newMessage) => {
    if (newMessage && newMessage.isNewMsg && !newMessage.isSentByMe) {
        let message = window.WAPI.processMessageObj(newMessage, false, false);
        if (message) {
            window.WAPI._newMessagesQueue.push(message);
            window.WAPI._newMessagesBuffer.push(message);
        }

        // Starts debouncer time to don t call a callback for each message if more than one message arrives
        // in the same second
        if (!window.WAPI._newMessagesDebouncer && window.WAPI._newMessagesQueue.length > 0) {
            window.WAPI._newMessagesDebouncer = setTimeout(() => {
                let queuedMessages = window.WAPI._newMessagesQueue;

                window.WAPI._newMessagesDebouncer = null;
                window.WAPI._newMessagesQueue = [];

                let removeCallbacks = [];

                window.WAPI._newMessagesCallbacks.forEach(function(callbackObj) {
                    if (callbackObj.callback !== undefined) {
                        callbackObj.callback(queuedMessages);
                    }
                    if (callbackObj.rmAfterUse === true) {
                        removeCallbacks.push(callbackObj);
                    }
                });

                // Remove removable callbacks.
                removeCallbacks.forEach(function(rmCallbackObj) {
                    let callbackIndex = window.WAPI._newMessagesCallbacks.indexOf(rmCallbackObj);
                    window.WAPI._newMessagesCallbacks.splice(callbackIndex, 1);
                });
            }, 1000);
        }
    }
});

window.WAPI._unloadInform = (event) => {
    // Save in the buffer the ungot unreaded messages
    window.WAPI._newMessagesBuffer.forEach((message) => {
        Object.keys(message).forEach(key => message[key] === undefined ? delete message[key] : '');
    });
    sessionStorage.setItem("saved_msgs", JSON.stringify(window.WAPI._newMessagesBuffer));

    // Inform callbacks that the page will be reloaded.
    window.WAPI._newMessagesCallbacks.forEach(function(callbackObj) {
        if (callbackObj.callback !== undefined) {
            callbackObj.callback({
                status: -1,
                message: 'page will be reloaded, wait and register callback again.'
            });
        }
    });
};

window.addEventListener("unload", window.WAPI._unloadInform, false);
window.addEventListener("beforeunload", window.WAPI._unloadInform, false);
window.addEventListener("pageunload", window.WAPI._unloadInform, false);

/**
 * Registers a callback to be called when a new message arrives the WAPI.
 * @param rmCallbackAfterUse - Boolean - Specify if the callback need to be executed only once
 * @param done - function - Callback function to be called when a new message arrives.
 * @returns {boolean}
 */
window.WAPI.waitNewMessages = function(rmCallbackAfterUse = true, done) {
    window.WAPI._newMessagesCallbacks.push({
        callback: done,
        rmAfterUse: rmCallbackAfterUse
    });
    return true;
};

/**
 * Reads buffered new messages.
 * @param done - function - Callback function to be called contained the buffered messages.
 * @returns {Array}
 */
window.WAPI.getBufferedNewMessages = function(done) {
    let bufferedMessages = window.WAPI._newMessagesBuffer;
    window.WAPI._newMessagesBuffer = [];
    if (done !== undefined) {
        done(bufferedMessages);
    }
    return bufferedMessages;
};
/** End new messages observable functions **/

window.WAPI.sendImage = function(imgBase64, chatid, filename, caption) {
    // var idUser = new window.Store.UserConstructor(chatid);
    var idUser = new Store.WidFactory.createWid(chatid, {
        intentionallyUsePrivateConstructor: true
    });
	
    
        return Store.FindChat.findChat(idUser).then((chat) => {
                    var mediaBlob = window.WAPI.base64ImageToFile(imgBase64, filename);
            var mc = new Store.MediaCollection(chat);
            
            //Deprecated  - Mike Lustosa 19/02/2020
            /*mc.processFiles([mediaBlob], chat, 1).then(() => {
                var media = mc.models[0];
                media.sendToChat(chat, {
                    caption: caption
                });
                if (done !== undefined) done(true);
            });*/
    
            //New - Mike Lustosa 19/02/2020
            mc.processAttachments([{file: mediaBlob}, 1], chat, 1).then(() => {
                let media = mc.models[0];
                media.sendToChat(chat, {caption:caption});
                return true;
            });
        });
    

    // return Store.FindChat.findChat(idUser).then((chat) => {
    //     var mediaBlob = window.WAPI.base64ImageToFile(imgBase64, filename);
    //     var mc = new Store.MediaCollection(chat);
        
    //     //Deprecated  - Mike Lustosa 19/02/2020
    //     /*mc.processFiles([mediaBlob], chat, 1).then(() => {
    //         var media = mc.models[0];
    //         media.sendToChat(chat, {
    //             caption: caption
    //         });
    //         if (done !== undefined) done(true);
    //     });*/

    //     //New - Mike Lustosa 19/02/2020
    //     mc.processAttachments([{file: mediaBlob}, 1], chat, 1).then(() => {
    //         let media = mc.models[0];
    //         media.sendToChat(chat, {caption:caption});
    //         if (done !== undefined) done(true);
    //     });
    // });

}


window.WAPI.sendMessageToID = function(chatid, msgText) {
    var idUser = new window.Store.UserConstructor(chatid, {
        intentionallyUsePrivateConstructor: true
    });

    console.log(idUser)

    const teste = Store.FindChat.findChat(idUser)
        .then(chatid => {
            console.log(teste)
            var mc = new Store.SendTextMsgToChat(chatid, msgText);
            return true;
        })

    return teste

}

window.WAPI.base64ImageToFile = function(b64Data, filename) {
    var arr = b64Data.split(',');
    var mime = arr[0].match(/:(.*?);/)[1];
    var bstr = atob(arr[1]);
    var n = bstr.length;
    var u8arr = new Uint8Array(n);

    while (n--) {
        u8arr[n] = bstr.charCodeAt(n);
    }

    return new File([u8arr], filename, {
        type: mime
    });
};

/**
 * Send contact card to a specific chat using the chat ids
 *
 * @param {string} to '000000000000@c.us'
 * @param {string|array} contact '111111111111@c.us' | ['222222222222@c.us', '333333333333@c.us, ... 'nnnnnnnnnnnn@c.us']
 */
window.WAPI.sendContact = function(to, contact) {
    if (!Array.isArray(contact)) {
        contact = [contact];
    }
    contact = contact.map((c) => {
        return WAPI.getChat(c).__x_contact;
    });

    if (contact.length > 1) {
        window.WAPI.getChat(to).sendContactList(contact);
    } else if (contact.length === 1) {
        window.WAPI.getChat(to).sendContact(contact[0]);
    }
};

/**
 * Create an chat ID based in a cloned one
 *
 * @param {string} chatId '000000000000@c.us'
 */
window.WAPI.getNewMessageId = function(chatId) {
    var newMsgId = Store.Msg.models[0].__x_id.clone();

    newMsgId.fromMe = true;
    newMsgId.id = WAPI.getNewId().toUpperCase();
    newMsgId.remote = chatId;
    newMsgId._serialized = `${newMsgId.fromMe}_${newMsgId.remote}_${newMsgId.id}`

    return newMsgId;
};

/**
 * Send VCARD
 *
 * @param {string} chatId '000000000000@c.us'
 * @param {string} vcard vcard as a string
 * @param {string} contactName The display name for the contact. CANNOT BE NULL OTHERWISE IT WILL SEND SOME RANDOM CONTACT FROM YOUR ADDRESS BOOK.
 * @param {string} contactNumber If supplied, this will be injected into the vcard (VERSION 3 ONLY FROM VCARDJS) with the WA id to make it show up with the correct buttons on WA.
 */
window.WAPI.sendVCard = async function (chatId, contactNumber, contactName) {
    
    var idUser = new window.Store.UserConstructor(chatId, {
        intentionallyUsePrivateConstructor: true
    });

    const inChat = await WAPI.getContact(chatId)
    const cont = await WAPI.getContact(contactNumber)
    const newMsgId = await WAPI.getNewMessageId(chatId)
    
    // console.log(Store.addAndSendMsgToChat)
    // console.log(cont)

    if(!cont){
        return
    }

    console.log(cont)

    var cont2 = cont
    cont2.userid = contactNumber.substring(0, contactNumber.length - 5)

    let queue = Store.Chat.get(chatId)

    const chat = await Store.FindChat.findChat(idUser)
    
    // chat.addQueue = queue.addQueue
    // chat.addQueue.enqueue = queue.addQueue.__proto__.enqueue
    // // chat.msgs = queue.msgs
    // // chat.msgs.add = queue.msgs.__proto__.add
    // chat.sendQueue = queue.sendQueue
    // chat.sendQueue.enqueue = queue.sendQueue.__proto__.enqueue


    const newchat = Object.assign(chat, queue);
    
    // chat.lastReceivedKey._serialized = inChat._serialized;
    // chat.lastReceivedKey.id = inChat.id;

    // var tempMsg = Object.create(Store.Msg.models.filter(msg => msg.__x_isSentByMe && !msg.quotedMsg)[0]);
    const fromWid = await window.Store.Conn.wid
    const name = !contactName ? cont.__x_formattedTitle : contactName
    const body = await window.Store.Vcard.vcardFromContactModel(cont2)
    console.log(body.vcard)

    var message = {
        ack: 0,
        id: newMsgId,
        // local: !0,
        self: "in",
        t: parseInt(new Date().getTime() / 1000),
        to: newchat.id,
        isNewMsg: true,
        type: "vcard",
        from: fromWid,
        // clientUrl:undefined,
        // directPath:undefined,
        // filehash:undefined,
        // uploadhash:undefined,
        // mediaKey:undefined,
        // isQuotedMsgAvailable:false,
        // invis:false,
        // mediaKeyTimestamp:undefined,
        // mimetype:undefined,
        // height:undefined,
        // width:undefined,
        // ephemeralStartTimestamp:undefined,
        body: body.vcard,
        // mediaData:undefined,
        isQuotedMsgAvailable: false,
        // subtype: contactName, 
        vcardFormattedName: name
    };
    // Object.assign(tempMsg, extend);
    console.log(Store.addAndSendMsgToChat)
    return (await Promise.all(Store.addAndSendMsgToChat(newchat, message)))[1]=="success"
};


/**
 * Block contact
 * @param {string} id '000000000000@c.us'
 * @param {*} done - function - Callback function to be called when a new message arrives.
 */
window.WAPI.contactBlock = function(id, done) {
        const contact = window.Store.Contact.get(id);
        if (contact !== undefined) {
            contact.setBlock(!0);
            done(true);
            return true;
        }
        done(false);
        return false;
    }
    /**
     * unBlock contact
     * @param {string} id '000000000000@c.us'
     * @param {*} done - function - Callback function to be called when a new message arrives.
     */
window.WAPI.contactUnblock = function(id, done) {
    const contact = window.Store.Contact.get(id);
    if (contact !== undefined) {
        contact.setBlock(!1);
        done(true);
        return true;
    }
    done(false);
    return false;
}


/** Joins a group via the invite link, code, or message
 * @param link This param is the string which includes the invite link or code. The following work:
 * - Follow this link to join my WA group: https://chat.whatsapp.com/DHTGJUfFJAV9MxOpZO1fBZ
 * - https://chat.whatsapp.com/DHTGJUfFJAV9MxOpZO1fBZ
 * - DHTGJUfFJAV9MxOpZO1fBZ
 * @returns Promise<string | boolean> Either false if it didn't work, or the group id.
 */
window.WAPI.joinGroupViaLink = async function(link){
    let code = link;
    //is it a link? if not, assume it's a code, otherwise, process the link to get the code.
    if(link.includes('chat.whatsapp.com')) {
        if(!link.match(/chat.whatsapp.com\/([\w\d]*)/g).length) return false;
        code = link.match(/chat.whatsapp.com\/([\w\d]*)/g)[0].replace('chat.whatsapp.com\/','');
    }
    const group = await Store.GroupInvite.joinGroupViaInvite(code);
    if(!group.id) return false;
    return group.id._serialized
}

/**
 * Add participant to Group
 * @param {*} idGroup '0000000000-00000000@g.us'
 * @param {*} idParticipant '000000000000@c.us'
 */
window.WAPI.addParticipant = async function (idGroup, idParticipant) {
    const chat = Store.Chat.get(idGroup);
    const add = Store.Contact.get(idParticipant);
    await window.Store.Participants.addParticipants(chat, [add]);
    return true;
}


/**
 * Remove participant of Group
 * @param {*} idGroup '0000000000-00000000@g.us'
 * @param {*} idParticipant '000000000000@c.us'
 */
window.WAPI.removeParticipant = async function (idGroup, idParticipant) {
    const chat = Store.Chat.get(idGroup);
    const rm = chat.groupMetadata.participants.get(idParticipant);
    await window.Store.Participants.removeParticipants(chat, [rm]);
    return true;
}

/**
 * Promote Participant to Admin in Group
 * @param {*} idGroup '0000000000-00000000@g.us'
 * @param {*} idParticipant '000000000000@c.us'
 */
window.WAPI.promoteParticipant = async function (idGroup, idParticipant) {
    const chat = Store.Chat.get(idGroup);
    const promote = chat.groupMetadata.participants.get(idParticipant);
    await window.Store.Participants.promoteParticipants(chat, [promote]);
    return true;
}

/**
 * Demote Admin of Group
 * @param {*} idGroup '0000000000-00000000@g.us'
 * @param {*} idParticipant '000000000000@c.us'
 */
window.WAPI.demoteParticipant = async function (idGroup, idParticipant) {
    await window.Store.WapQuery.demoteParticipants(idGroup, [idParticipant])
    const chat = Store.Chat.get(idGroup);
    const demote = chat.groupMetadata.participants.get(idParticipant);
    await window.Store.Participants.demoteParticipants(chat, [demote])
    return true
   
}

//Nova funcao alternativa para enviar mensagens(Nao envia para grupos)
//Criada em 27/11/2019 Mike
window.WAPI.sendMessageToID2 = function(id, msgText) {
    
    window.Store.WapQuery.queryExist(id).then(function(e) {
        if (e.status === 200) {
            window.Store.FindChat.findChat(e.jid).then((chat) => {
                try {
                    window.Store.SendTextMsgToChat(chat, msgText);
                    return true;
                } catch (e) {
                    return false;
                }
            });
            return true;
        } else {
            return false;
        }
    });

        return false;
    
}

//Validar numero whatsapp 12/02/2020
window.WAPI.isValidNumber = async function (phoneId) {
    isValid = window.Store.WapQuery.queryExist(phoneId).then(result => {
        return result.jid !== undefined;
    }).catch((e) => {
        return false;
    });

    return isValid;
};

/** 28/04/2020 - Mike
 * Send location
 *
 * @param {string} chatId '558199999999@c.us'
 * @param {string} lat latitude
 * @param {string} lng longitude
 * @param {string} loc Texto link para a localizacao
 */
 
 
window.WAPI.sendLocation = async function (chatId, lat, lng, loc) {

    var idUser = new window.Store.UserConstructor(chatId, {
        intentionallyUsePrivateConstructor: true
    });

    const fromwWid = await window.Store.Conn.wid;

    const inChat = await Store.FindChat.findChat(idUser)

    let queue = Store.Contact.get(chatId);

    const newchat = Object.assign(queue, inChat);

    console.log(queue)
    
    console.log(newchat)
    // chat.lastReceivedKey._serialized = inChat._serialized;
    // chat.lastReceivedKey.id = inChat.id;

    // var tempMsg = Object.create(Store.Msg.models.filter(msg => msg.__x_isSentByMe && !msg.quotedMsg)[0]);
    var newId = window.WAPI.getNewMessageId(chatId);
    var message = {
        ack: 0,
        id: newId,
        local: true,
        self: "in",
        t: parseInt(new Date().getTime() / 1000),
        to: chatId,
        isNewMsg: true,
        type: "location",
        lat,
        lng,
        loc,
        from: fromwWid
    };
    // Object.assign(tempMsg, extend);
    return await Promise.all(Store.addAndSendMsgToChat(newchat, message))
};

// Novas Funcoes incluidas por Marcelo Santos

window.WAPI.quickClean = function (ob) {return JSON.parse(JSON.stringify(ob))};

window.WAPI.setMyName = async function (newName) {
	return await window.Store.Perfil.setPushname(newName);
}

window.WAPI.clearChat = async function (id) {
    return await Store.ChatUtil.sendClear(Store.Chat.get(id),true);
}

window.WAPI.setMyStatus = function (newStatus) {
    return Store.MyStatus.setMyStatus(newStatus)
}

window.WAPI.revokeGroupInviteLink = async function (chatId) {
    var chat = Store.Chat.get(chatId);
    if(!chat.isGroup) return false;
    await Store.GroupInvite.revokeGroupInvite(chat);
    return true;
}

function SetConsoleMessageString(jsName, StringValue) {
    Obj = {
        name: jsName,
        result: StringValue
    }
    console.log(JSON.stringify(Obj));
}


window.WAPI.getGroupInviteLink = async function (chatId) {
    let chat = Store.Chat.get(chatId);

	let code = chat.groupMetadata && chat.groupMetadata.inviteCode  ? 
	chat.groupMetadata.inviteCode : await Store.GroupInvite.sendQueryGroupInviteCode(chat.id);	
    SetConsoleMessageString("GetGroupInviteLink", `https://chat.whatsapp.com/${code}`);
	return `https://chat.whatsapp.com/${code}`;

}

/**
 * Returns an object with all of your host device details
 */
window.WAPI.getMe = function(){
   	
	vMe = {...WAPI.quickClean({
        ...Store.Contact.get(Store.Me.wid).attributes,
        ...Store.Me.attributes
    }),
    me:Store.Me.me};
 
  SetConsoleMessage("GetMe", JSON.stringify(vMe)); 
  
  return vMe;
    
}

window.WAPI.getStatus = async (id) => {
 SetConsoleMessage("GetStatusMessage", JSON.stringify(await Store.MyStatus.getStatus(id)));	 
 //return status; 
}

window.WAPI.checkNumberStatus = async function (id) {
    try {
        const result = await window.Store.WapQuery.queryExist(id);
        if (result.jid === undefined) throw 404;
        const data = window.WAPI._serializeNumberStatusObj(result);
        if (data.status == 200) data.numberExists = true
      SetConsoleMessage("NewCheckIsValidNumber",    JSON.stringify({ id : id, valid : data.numberExists}));     
	 return data;
		
    } catch (e) {
            SetConsoleMessage("NewCheckIsValidNumber", JSON.stringify({ id : id,  valid : false}));
			return window.WAPI._serializeNumberStatusObj({
                status: e,
                jid: id
            });
    }
};

window.WAPI.sendButtons = async function (chatId, title, buttons, description = '') {
    let options = {
        footer: description,
        isDynamicReplyButtonsMsg: true,
        dynamicReplyButtons: buttons
    };
    
    return WAPI.sendMessageOptions(chatId, title, options);
};

window.WAPI.sendMessageOptions = async function (chatId, content, options = {}) {
    var idUser = new window.Store.UserConstructor(chatId, {
        intentionallyUsePrivateConstructor: true
    });

    let queue = Store.Chat.get(chatId)

    const newChat = await Store.FindChat.findChat(idUser)

    const chat = Object.assign(newChat, queue);
    

    let attOptions = {};
    if (options.attachment) {
      attOptions = await WWebJS.processMediaData(
        options.attachment,
        options.sendAudioAsVoice
      );
      content = attOptions.preview;
      delete options.attachment;
    }
  
    let quotedMsgOptions = {};
    if (options.quotedMessageId) {
      let quotedMessage = await getMessageById(
        options.quotedMessageId,
        null,
        false
      );
      if (quotedMessage && quotedMessage.canReply()) {
        quotedMsgOptions = quotedMessage.msgContextInfo(chat);
      }
      delete options.quotedMessageId;
    }
  
    if (options.mentionedJidList) {
      options.mentionedJidList = options.mentionedJidList.map(
        (cId) => window.Store.Contact.get(cId).id
      );
    }
  
    let locationOptions = {};
    if (options.location) {
      locationOptions = {
        type: 'location',
        loc: options.location.description,
        lat: options.location.latitude,
        lng: options.location.longitude,
      };
      delete options.location;
    }
  
    let vcardOptions = {};
    if (options.contactCard) {
      let contact = window.Store.Contact.get(options.contactCard);
      vcardOptions = {
        body: window.Store.VCard.vcardFromContactModel(contact).vcard,
        type: 'vcard',
        vcardFormattedName: contact.formattedName,
      };
      delete options.contactCard;
    } else if (options.contactCardList) {
      let contacts = options.contactCardList.map((c) =>
        window.Store.Contact.get(c)
      );
      let vcards = contacts.map((c) =>
        window.Store.VCard.vcardFromContactModel(c)
      );
      vcardOptions = {
        type: 'multi_vcard',
        vcardList: vcards,
        body: undefined,
      };
      delete options.contactCardList;
    } else if (
      options.parseVCards &&
      typeof content === 'string' &&
      content.startsWith('BEGIN:VCARD')
    ) {
      delete options.parseVCards;
      try {
        const parsed = await window.Store.VCard.parseVcard(content);
        if (parsed) {
          vcardOptions = {
            type: 'vcard',
            vcardFormattedName: await window.Store.VCard.vcardGetNameFromParsed(
              parsed
            ),
          };
        }
      } catch (_) {
        // not a vcard
      }
    }
  
    if (options.linkPreview) {
      delete options.linkPreview;
      const link = await window.Store.Validators.findLink(content);
      if (link) {
        const preview = await window.Store.Wap2.default.queryLinkPreview(
          link.url
        );
        preview.preview = true;
        preview.subtype = 'url';
        options = { ...options, ...preview };
      }
    }
    const newMsgId = await window.WAPI.getNewMessageId(chat.id);
    const fromwWid = await Store.UserPrefs.getMaybeMeUser();
    const message = {
      ...options,
      id: newMsgId,
      ack: 0,
      body: content,
      from: fromwWid,
      to: chat.id,
      local: !0,
      self: 'out',
      t: parseInt(new Date().getTime() / 1000),
      isNewMsg: !0,
      type: 'chat',
      ...locationOptions,
      ...attOptions,
      ...quotedMsgOptions,
      ...vcardOptions,
    };
  
    await window.Store.addAndSendMsgToChat(chat, message);
  
    return newMsgId._serialized;
};
