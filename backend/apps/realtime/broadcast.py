from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer


def broadcast_to_order(order_id, event, **payload):
    channel_layer = get_channel_layer()
    async_to_sync(channel_layer.group_send)(
        f"order_{order_id}",
        {"type": "order.event", "payload": {"event": event, **payload}},
    )


def broadcast_to_team(team_id, event, **payload):
    channel_layer = get_channel_layer()
    async_to_sync(channel_layer.group_send)(
        f"team_{team_id}",
        {"type": "team.event", "payload": {"event": event, **payload}},
    )
