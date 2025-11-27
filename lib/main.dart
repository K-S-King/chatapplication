import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const WelcomeScreen(), // Changed from MainScreen
    );
  }
}

// ============================================
// NEW: WELCOME/USERNAME ENTRY SCREEN
// ============================================

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _joinChat() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MainScreen(userName: _nameController.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade400, Colors.blue.shade700],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Icon/Logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chat_bubble_rounded,
                          size: 60,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Welcome Text
                      const Text(
                        'Welcome to',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Chat App',
                        style: TextStyle(
                          fontSize: 42,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 50),

                      // Name Input Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Enter your name to start chatting',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Name TextField
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Your name',
                                prefixIcon: const Icon(Icons.person_outline),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (value.trim().length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              onFieldSubmitted: (_) => _joinChat(),
                            ),
                            const SizedBox(height: 24),

                            // Join Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _joinChat,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Start Chatting',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Info Text
                      Text(
                        'Connect with friends in real-time',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================
// MAIN SCREEN (Updated to accept userName)
// ============================================

class MainScreen extends StatefulWidget {
  final String userName;

  const MainScreen({super.key, required this.userName});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ChatListScreen(currentUserName: widget.userName),
      const StatusScreen(),
      ProfileScreen(userName: widget.userName),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class ChatListScreen extends StatelessWidget {
  final String currentUserName;

  const ChatListScreen({super.key, required this.currentUserName});

  @override
  Widget build(BuildContext context) {
    final users = [
      {
        'name': 'divyansh',
        'avatar': '👩‍💼',
        'lastMsg': 'Hey! How are you?',
        'online': true,
      },
      {
        'name': 'Mike Wilson',
        'avatar': '👨‍💻',
        'lastMsg': 'See you tomorrow',
        'online': true,
      },
      {
        'name': 'Emma Davis',
        'avatar': '👩‍🎨',
        'lastMsg': 'Thanks!',
        'online': false,
      },
      {
        'name': 'Alex Brown',
        'avatar': '👨‍🔬',
        'lastMsg': 'Got it',
        'online': false,
      },
      {
        'name': 'Lisa Anderson',
        'avatar': '👩‍🏫',
        'lastMsg': 'Perfect!',
        'online': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    userName: user['name'] as String,
                    avatar: user['avatar'] as String,
                    isOnline: user['online'] as bool,
                    currentUserName: currentUserName,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user['avatar'] as String,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      if (user['online'] as bool)
                        Positioned(
                          right: 2,
                          bottom: 2,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user['lastMsg'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.message),
      ),
    );
  }
}

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      {
        'name': 'My Status',
        'avatar': '😊',
        'time': 'Tap to add status',
        'isMe': true,
      },
      {
        'name': 'Sarah Johnson',
        'avatar': '👩‍💼',
        'time': '10 minutes ago',
        'isMe': false,
      },
      {
        'name': 'Mike Wilson',
        'avatar': '👨‍💻',
        'time': '1 hour ago',
        'isMe': false,
      },
      {
        'name': 'Emma Davis',
        'avatar': '👩‍🎨',
        'time': '3 hours ago',
        'isMe': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isMe = status['isMe'] as bool;

          return InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isMe ? Colors.grey[400]! : Colors.green,
                        width: 3,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          status['avatar'] as String,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          status['time'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isMe)
                    const Icon(Icons.add_circle, color: Colors.blue, size: 28),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        userName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hey there! I am using Chat App',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(Icons.phone, 'Phone', '+1 234 567 8900'),
            _buildInfoCard(
              Icons.email,
              'Email',
              '${userName.toLowerCase().replaceAll(' ', '')}@example.com',
            ),
            _buildInfoCard(Icons.cake, 'Birthday', 'January 15, 1995'),
            _buildInfoCard(Icons.location_on, 'Location', 'India'),
            const SizedBox(height: 16),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.block, color: Colors.red),
                    title: const Text(
                      'Blocked Contacts',
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSection('Account', [
            _buildSettingTile(
              Icons.key,
              'Privacy',
              'Control your privacy settings',
            ),
            _buildSettingTile(
              Icons.security,
              'Security',
              'Password and security',
            ),
            _buildSettingTile(Icons.language, 'Language', 'English'),
          ]),
          _buildSection('Notifications', [
            _buildSettingTile(
              Icons.notifications,
              'Message Notifications',
              'Sounds and vibrations',
            ),
            _buildSettingTile(
              Icons.notification_important,
              'Group Notifications',
              'Enable group notifications',
            ),
          ]),
          _buildSection('Appearance', [
            _buildSettingTile(Icons.dark_mode, 'Theme', 'Light mode'),
            _buildSettingTile(
              Icons.wallpaper,
              'Chat Wallpaper',
              'Change chat background',
            ),
            _buildSettingTile(Icons.text_fields, 'Font Size', 'Medium'),
          ]),
          _buildSection('Storage', [
            _buildSettingTile(Icons.storage, 'Storage Usage', '1.2 GB'),
            _buildSettingTile(
              Icons.delete,
              'Clear Cache',
              'Free up storage space',
            ),
          ]),
          _buildSection('About', [
            _buildSettingTile(Icons.info, 'App Version', '1.0.0'),
            _buildSettingTile(Icons.help, 'Help Center', 'Get support'),
            _buildSettingTile(
              Icons.description,
              'Terms & Privacy',
              'Read policies',
            ),
          ]),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}

// ============================================
// SOCKET.IO INTEGRATED CHAT SCREEN (Updated)
// ============================================

class ChatScreen extends StatefulWidget {
  final String userName;
  final String avatar;
  final bool isOnline;
  final String currentUserName;

  const ChatScreen({
    super.key,
    required this.userName,
    required this.avatar,
    required this.isOnline,
    required this.currentUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late IO.Socket socket;

  // IMPORTANT: Replace with your Render URL
  final String serverUrl = 'https://chat-backend-u509.onrender.com';

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('Connected to server');
      socket.emit('join', widget.currentUserName);
    });

    socket.on('messageReceived', (data) {
      print('Message received: $data');
      setState(() {
        _messages.add(
          ChatMessage(
            text: data['message'],
            isSentByMe: false,
            userName: data['userName'],
          ),
        );
      });
      _scrollToBottom();
    });

    socket.on('userStatusChanged', (data) {
      print('User status changed: $data');
    });

    socket.onConnectError((data) {
      print('Connection Error: $data');
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();

    final messageData = {
      'userName': widget.currentUserName,
      'message': messageText,
    };

    socket.emit('sendMessage', messageData);

    setState(() {
      _messages.add(
        ChatMessage(
          text: messageText,
          isSentByMe: true,
          userName: widget.currentUserName,
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.avatar,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                if (widget.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userName, style: const TextStyle(fontSize: 16)),
                Text(
                  widget.isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.avatar,
                          style: const TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start chatting with ${widget.userName}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: message.isSentByMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: message.isSentByMe
                                    ? Colors.blue
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(
                                    message.isSentByMe ? 20 : 4,
                                  ),
                                  bottomRight: Radius.circular(
                                    message.isSentByMe ? 4 : 20,
                                  ),
                                ),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: message.isSentByMe
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isSentByMe;
  final String userName;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.userName,
  });
}
