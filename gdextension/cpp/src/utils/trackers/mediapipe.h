#ifndef MEDIAPIPE_H
#define MEDIAPIPE_H

#include <godot_cpp/classes/json.hpp>
#include <godot_cpp/classes/packet_peer_udp.hpp>
#include <godot_cpp/classes/thread.hpp>
#include <godot_cpp/classes/udp_server.hpp>
#include <godot_cpp/core/binder_common.hpp>

#include "abstract_tracker.h"

class Mediapipe : public AbstractTracker {
    GDCLASS(Mediapipe, AbstractTracker);

    const double SERVER_POLL_DELAY = 60.0;

    Ref<UDPServer> server;
    Ref<PacketPeerUDP> connection;
    Ref<Thread> receive_thread;
    int receive_pid;
    bool stop_reception;

    Error _receive();

   protected:
    static void _bind_methods();

   public:
    virtual Error start(const Variant **p_args, GDExtensionInt p_arg_count, GDExtensionCallError &p_error) override;
    virtual Error stop() override;

    static StringName identifier();

    Mediapipe();
    ~Mediapipe();
};

#endif  // MEDIAPIPE_H
