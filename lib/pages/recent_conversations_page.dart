import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../providers/auth_provider.dart';
import '../services/db_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/navigation_service.dart';
import '../pages/conversation_page.dart';

class RecentConversationsPage extends StatelessWidget {
  final double _height;
  final double _width;

  RecentConversationsPage(this._height, this._width);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
          child: _conversationsListViewWidget(),
    ),
    );
  }
  Widget _conversationsListViewWidget(){
    return Builder(
      builder: (BuildContext context){
      var _auth = Provider.of<AuthProvider>(context);
      return Container(
        height: _height,
        width: _width,
        child: StreamBuilder<List<ConversationSnippet>>(
          stream: DBService.instance.getUserConversations(_auth.user!.uid),
          builder: (context, _snapshot) {
            var _data = _snapshot.data ;

            if(_data != null){
              _data.removeWhere((_c) {
                return _c.timestamp == null;
              });
              return _data.length != 0 ? ListView.builder(
                itemCount: _data?.length,
                itemBuilder: (_context, _index) {
                  var _dataIndex = _data![_index];
                  return ListTile(
                    onTap: () {
                      NavigationService.instance.navigateToRoute(MaterialPageRoute(builder: (BuildContext _context){
                        return ConversationPage(_dataIndex.conversationID, _dataIndex.id, _dataIndex.name, _dataIndex.image);
                      },),);
                    },
                    title: Text(_dataIndex.name),
                    subtitle: Text(_dataIndex.type == MessageType.Text ? _dataIndex.lastMessage : "Attachment : Image" ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(_dataIndex.image),
                        ),
                      ),
                    ),
                    trailing: _listTileTrailingWidget(_dataIndex.timestamp),
                  );
                },
              ): Align(
                child: Text(
                    "No Conversations Yet!",
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 15.0,
                  ),
                ),
              );
            } else{
            return SpinKitWanderingCubes(
            color: Colors.blue,
            size: 50.0,
            );
            }
      },
        ),
      );
    },
    );
  }
  Widget _listTileTrailingWidget(Timestamp _lastMessageTimestamp){
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
        "Last Message",
          style: TextStyle(fontSize: 15),
        ),
        Text(
          timeago.format(_lastMessageTimestamp.toDate()),
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
