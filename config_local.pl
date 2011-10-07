use utf8;

return +{
    storage => {
        backend => {
            class => "Cache::Memcached::Fast",
            args  => {
                servers => ["127.0.0.1:11211"],
            },
        },
    },
    cache => {
        class => "Cache::Memcached::Fast",
        args  => {
            servers => ["127.0.0.1:11211"],
        },
        expires => 86400,
    },
};
