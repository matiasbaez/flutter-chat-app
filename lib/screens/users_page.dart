
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/services/services.dart';
import 'package:chat/models/models.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({ Key? key }) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  List<User> users = [];
  final userService = UsersService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name, style: const TextStyle(color: Colors.black45)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon( Icons.exit_to_app, color: Colors.black45 ),
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.removeToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only( right: 10 ),
            child: socketService.serverStatus == ServerStatus.online
            ? Icon( Icons.check_circle, color: Colors.blue[400] )
            : const Icon( Icons.offline_bolt, color: Colors.red ),
            // child: Icon( Icons.offline_bolt, color: Colors.red ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.blue[400] ),
          waterDropColor: Colors.blue[400] as Color,
        ),
        onRefresh: _getUsers,
        onLoading: _onLoading,
        child: _userListView(),
      ),
    );
  }

  ListView _userListView() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: ( _, index ) => _userListTile(users[index]),
      separatorBuilder: ( _, index ) => const Divider(),
      itemCount: users.length,
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(user.name),
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100)
        )
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  void _getUsers() async{
    // monitor network fetch
    users = await userService.getUsers();
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    setState(() {});
    _refreshController.loadComplete();
  }
}