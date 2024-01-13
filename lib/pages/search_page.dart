import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../services/db_service.dart';
import '../providers/auth_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/navigation_service.dart';
import '../pages/conversation_page.dart';

class SearchPage extends StatefulWidget {
  double _height;
  double _width;

  SearchPage(this._height, this._width);

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  late String _searchText;
  late AuthProvider _auth;

  _SearchPageState() {
    _searchText = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _searchPageUI(),
      ),
    );
  }

  Widget _searchPageUI() {
    return Builder(
      builder: (BuildContext context) {
        _auth = Provider.of<AuthProvider>(context);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _userSearchField(),
            _userListView(),
          ],
        );
      },
    );
  }

  Widget _userSearchField() {
    return Container(
      height: this.widget._height * 0.08,
      width: this.widget._width,
      padding: EdgeInsets.symmetric(vertical: this.widget._height * 0.02),
      child: TextField(
        autocorrect: false,
        style: TextStyle(color: Colors.white),
        onSubmitted: (_input) {
          setState(() {
            _searchText = _input;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          labelStyle: TextStyle(color: Colors.white),
          labelText: "Search",
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _userListView() {
    return StreamBuilder<List<Contact>>(
      stream: DBService.instance.getUserInDB(_searchText),
      builder: (_context, _snapshot) {
        var _usersData = _snapshot.data;
        if (_usersData != null) {
          _usersData.removeWhere((_contact) => _contact.id == _auth.user?.uid);
        }

        return _snapshot.hasData
            ? Container(
                height: this.widget._height * 0.7,
                child: ListView.builder(
                  itemCount: _usersData?.length,
                  itemBuilder: (BuildContext context, int _index) {
                    var _userData = _usersData![_index];
                    var _currentTime = DateTime.now();
                    var _recepientID = _usersData[_index].id;
                    var _isUserActive = _userData.lastSeen?.toDate().isAfter(
                          _currentTime.subtract(
                            Duration(hours: 1),
                          ),
                        );
                    return ListTile(
                      onTap: () {
                        DBService.instance.createOrGetConversation(
                            _auth.user!.uid,
                            _recepientID!,
                            (String _conversationID) {
                              NavigationService.instance.navigateToRoute(MaterialPageRoute(builder: (_context){
                                return ConversationPage(
                                    _conversationID,
                                    _recepientID,
                                    _userData.name ?? "default name",
                                    _userData.image ?? "https://i.ibb.co/3hgwQPH/icons8-user-100.jpg",
                                );
                              }),
                              );
                              return Future(() => null);
                            },
                        );
                      },
                      title: Text(_userData.name ?? "default name"),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(_userData.image ??
                                "https://i.ibb.co/3hgwQPH/icons8-user-100.jpg"),
                          ),
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          (_isUserActive ?? false)
                              ? Text(
                                  "Active Now",
                                  style: TextStyle(fontSize: 15),
                                )
                              : Text(
                                  "last seen",
                                  style: TextStyle(fontSize: 15),
                                ),
                          (_isUserActive ?? false)
                              ? Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                )
                              : Text(
                                  timeago.format(
                                    _userData.lastSeen?.toDate(),
                                  ),
                                  style: TextStyle(fontSize: 15),
                                ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : SpinKitWanderingCubes(
                color: Colors.blue,
                size: 50.0,
              );
      },
    );
  }
}
