import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/db_service.dart';
import '../models/conversation.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/message.dart';
import '../services/media_service.dart';
import '../services/cloud_storage_service.dart';

class ConversationPage extends StatefulWidget {
  final String _conversationID;
  final String _receiverID;
  final String _receiverImage;
  final String _receiverName;
  ConversationPage(this._conversationID, this._receiverID, this._receiverName,
      this._receiverImage);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  GlobalKey<FormState> ?_formKey;
late ScrollController _listViewController;
  late AuthProvider _auth;
   late String _messageText;
  _ConversationPageState(){
    _formKey = GlobalKey<FormState>();
    _messageText = "";
    _listViewController = ScrollController();
  }
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(31, 31, 31, 1.0),
          title: Text(widget._receiverName),
        ),
        body: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: _conversationPageUI(),
        ),
    );
  }

  Widget _conversationPageUI() {
    return Builder(
      builder: (BuildContext _context) {
        _auth = Provider.of<AuthProvider>(_context);
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            _messageListView(),
            Align(
              alignment: Alignment.bottomCenter,
                child: _messageField(_context),
            ),
          ],
        );
      },
    );
  }

  Widget _messageListView() {
    return Container(
      height: _deviceHeight * 0.75,
      width: _deviceWidth,
      child: StreamBuilder<Conversation>(
        stream: DBService.instance.getConversation(this.widget._conversationID)
            as Stream<Conversation>,
        builder: (BuildContext _context, _snapshot) {
          Timer(Duration(milliseconds: 50), () => {
            _listViewController.jumpTo(_listViewController.position.maxScrollExtent),
          },
          );
          var _conversationData = _snapshot.data;
          if (_conversationData != null) {
            if(_conversationData.messages!= null && _conversationData.messages.length != 0){
              return ListView.builder(
                controller: _listViewController,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: _conversationData.messages.length,
                itemBuilder: (BuildContext _context, int _index) {
                  var _message = _conversationData.messages[_index];
                  bool _isOwnMessage = _message.senderID == _auth.user?.uid;
                  return _messageListViewChild(_isOwnMessage, _message);
                },
              );
            }else{
              return Align(
                alignment: Alignment.center,
                child: Text("Let's start a conversation"),
              );
            }
          } else {
            return SpinKitWanderingCubes(
              color: Colors.blue,
              size: 50.0,
            );
          }
        },
      ),
    );
  }
  Widget _messageListViewChild(bool _isOwnMessage, Message _message){
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        _isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
         ! _isOwnMessage ? _userImageWidget() : Container(),
          SizedBox(width: _deviceWidth * 0.02),
          _message.type == MessageType.Text
          ?  _textMessageBubble(
              _isOwnMessage, _message.content, _message.timestamp)
              : _imageMessageBubble(_isOwnMessage, _message.content, _message.timestamp),
        ],
      ),
    );
  }

  Widget _userImageWidget(){
    double _imageRadius = _deviceHeight*0.05;
    return Container(
      height: _imageRadius,
      width: _imageRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(this.widget._receiverImage),
        ),
      ),
    );
  }

  Widget _textMessageBubble(
      bool _isOwnMessage, String _message, Timestamp _timestamp) {
    List<Color> _colorScheme = _isOwnMessage
        ? [Colors.blue, Color.fromRGBO(42, 117, 188, 1)]
        : [Color.fromRGBO(69, 69, 69, 1), Color.fromRGBO(43, 43, 43, 1)];
    return Container(
      height: _deviceHeight * 0.075 + (_message.length /20 * 5.0),
      width: _deviceWidth * 0.75,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(_message),
          Text(
            timeago.format(_timestamp.toDate()),
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _imageMessageBubble(
      bool _isOwnMessage, String _imageURL, Timestamp _timestamp) {
    List<Color> _colorScheme = _isOwnMessage
        ? [Colors.blue, Color.fromRGBO(42, 117, 188, 1)]
        : [Color.fromRGBO(69, 69, 69, 1), Color.fromRGBO(43, 43, 43, 1)];
    return Container(
      height: _deviceHeight * 0.37,
      width: _deviceWidth * 0.75,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: _colorScheme,
          stops: [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: _deviceHeight *0.30,
            width:  _deviceWidth * 0.70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(_imageURL), fit: BoxFit.cover),
              )
            ),

          Text(
            timeago.format(_timestamp.toDate()),
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _messageField(BuildContext _context){
    return Container(
      height: _deviceHeight*0.08,
      decoration: BoxDecoration(
        color: Color.fromRGBO(43, 43, 43, 1),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth*0.04 , vertical: _deviceHeight*0.03
      ),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _messageTextField(),
            _sendMessageButton(_context),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField(){
    return SizedBox(
      width: _deviceWidth*0.55,
      child: TextFormField(
        validator: (_input){
          if(_input?.length == 0){
            return "Please enter a message";
          }
          return null;
        },
        onChanged: (_input){
          _formKey?.currentState?.save();

        },
        onSaved: (_input){
          setState(() {
            _messageText = _input!;
          });

        },
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "type a message",
        ),
        autocorrect: false,
      ),
    );
  }

  Widget _sendMessageButton(BuildContext _context){
    return Container(
      height: _deviceHeight*0.05,
      width: _deviceWidth*0.05,
      child: IconButton(
        icon: Icon(
            Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          if(_formKey?.currentState?.validate() ?? false){
            DBService.instance.sendMessage(
                this.widget._conversationID,
                Message(
                    senderID:_auth.user?.uid ?? '',
                    content: _messageText,
                    timestamp: Timestamp.now(),
                    type: MessageType.Text),
            );
            _formKey?.currentState?.reset();
            FocusScope.of(_context).unfocus();
          }
        }
      ),
    );
  }

  Widget _imageMessageButton(){
    return Container(
      height: _deviceHeight*0.05,
      width: _deviceWidth*0.05,
      child: FloatingActionButton(
        onPressed: ()async {
          var _image = await MediaService.instance.getImageFromLibrary();
          if(_image != null){
            var _result = await CloudStorageService.instance.uploadMediaMessage(_auth.user!.uid, _image);
            var _imageURL = await _result.ref.getDownloadURL();
            DBService.instance.sendMessage(
                this.widget._conversationID,
                Message(
                  content: _imageURL,
                  senderID: _auth.user!.uid,
                  timestamp: Timestamp.now(),
                  type: MessageType.Image
                ),
            );
          }
        },
        child: Icon(Icons.camera_enhance),
      ),
    );
  }
}
