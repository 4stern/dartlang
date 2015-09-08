/// A library to manage launching application.
library atom.launch;

import 'dart:async';

import 'atom.dart';
import 'utils.dart';

class LaunchManager implements Disposable {
  StreamController<Launch> _launchAdded = new StreamController.broadcast();
  StreamController<Launch> _launchChanged = new StreamController.broadcast();
  StreamController<Launch> _launchRemoved = new StreamController.broadcast();

  StreamController<Launch> _changedActiveLaunch = new StreamController.broadcast();

  Launch _activeLaunch;
  final List<Launch> _launches = [];

  LaunchManager();

  Launch get activeLaunch => _activeLaunch;

  List<Launch> get launches => _launches;

  void addLaunch(Launch launch) {
    _launches.add(launch);
    _activeLaunch = launch;

    // Automatically remove all dead launches.
    List removed = [];
    _launches.removeWhere((l) {
      if (l.isTerminated) removed.add(l);
      return l.isTerminated;
    });

    removed.forEach((l) => _launchRemoved.add(l));

    _launchAdded.add(launch);
    _changedActiveLaunch.add(launch);
  }

  void removeLaunch(Launch launch) {
    _launches.remove(launch);
    bool activeChanged = false;
    if (launch == _activeLaunch) {
      _activeLaunch = null;
      if (_launches.isNotEmpty) _activeLaunch = launches.first;
      activeChanged = true;
    }

    _launchRemoved.add(launch);
    if (activeChanged) _changedActiveLaunch.add(_activeLaunch);
  }

  void setActiveLaunch(Launch launch) {
    if (launch != _activeLaunch) {
      _activeLaunch = launch;
      _changedActiveLaunch.add(_activeLaunch);
    }
  }

  Stream<Launch> get onLaunchAdded => _launchAdded.stream;
  Stream<Launch> get onLaunchChanged => _launchChanged.stream;
  Stream<Launch> get onLaunchRemoved => _launchRemoved.stream;
  Stream<Launch> get onChangedActiveLaunch => _changedActiveLaunch.stream;

  void dispose() { }
}

class LaunchType {
  static const CLI = 'cli';
  static const SHELL = 'shell';
  static const SKY = 'sky';
  static const WEB = 'web';

  final String type;

  LaunchType(this.type);

  operator== (obj) => obj is LaunchType && obj.type == type;

  int get hashCode => type.hashCode;

  String toString() => type;
}

class Launch {
  final LaunchType launchType;
  final String title;
  final LaunchManager manager;

  StreamController<String> _stdout = new StreamController.broadcast();
  StreamController<String> _stderr = new StreamController.broadcast();

  int _exitCode;

  Launch(this.launchType, this.title, this.manager);

  int get exitCode => _exitCode;
  bool get errored => _exitCode != null && _exitCode != 0;

  bool get isRunning => _exitCode == null;
  bool get isTerminated => _exitCode != null;

  bool get isActive => manager.activeLaunch == this;

  Stream<String> get onStdout => _stdout.stream;
  Stream<String> get onStderr => _stderr.stream;

  void pipeStdout(String str) => _stdout.add(str);
  void pipeStderr(String str) => _stderr.add(str);

  void launchTerminated(int exitCode) {
    if (_exitCode != null) return;
    _exitCode = exitCode;

    if (errored) {
      atom.notifications.addError('${this} exited with error code ${exitCode}.');
    } else {
      atom.notifications.addSuccess('${this} finished.');
    }

    manager._launchChanged.add(this);
  }

  String toString() => '${launchType}: ${title}';
}
