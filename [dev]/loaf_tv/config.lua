cfg_tv_thing = {}

cfg_tv_thing['URL'] = 'https://www.youtube.com/embed/%s?autoplay=1&controls=1&disablekb=1&fs=0&rel=0&showinfo=0&iv_load_policy=3&start=%s'
-- cfg_tv_thing['URL'] = 'https://www.youtube.com/watch?v=%s&t=%s' -- use this if you want to be able to play copyrighted stuff. please note that ads will pop up every now and again, and full screen doesn't work
cfg_tv_thing['API'] = {
    ['URL'] = 'https://www.googleapis.com/youtube/v3/videos?id=%s&part=contentDetails&key=%s',
    ['Key'] = ''
}
cfg_tv_thing['DurationCheck'] = false -- this will automatically delete the browser (good for ram i guess?) once the video has finished (REQUIRES YOU TO ADD AN API KEY!!!!!)

cfg_tv_thing['Objects'] = {
    {
        ['Object'] = 'prop_tv_flat_01',
        ['Scale'] = 0.05,
        ['Offset'] = vec3(-0.925, -0.055, 1.0),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_michael',
        ['Scale'] = 0.035,
        ['Offset'] = vec3(-0.675, -0.055, 0.4),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_trev_tv_01',
        ['Scale'] = 0.012,
        ['Offset'] = vec3(-0.225, -0.01, 0.26),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_03b',
        ['Scale'] = 0.016,
        ['Offset'] = vec3(-0.3, -0.062, 0.18),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_03',
        ['Scale'] = 0.016,
        ['Offset'] = vec3(-0.3, -0.01, 0.4),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02b',
        ['Scale'] = 0.026,
        ['Offset'] = vec3(-0.5, -0.012, 0.525),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02',
        ['Scale'] = 0.026,
        ['Offset'] = vec3(-0.5, -0.012, 0.525),
        ['Distance'] = 7.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02',
        ['Scale'] = 0.026,
        ['Offset'] = vec3(-0.5, -0.012, 0.525),
        ['Distance'] = 7.5,
    },
}

Strings = {
    ['VideoHelp'] = 'Ecrire ~b~/tv ~y~youtube id~s~ pour mettre une vidéo.\nExemple: ~b~/tv ~y~3hqjseATp4g~s~',
    ['VolumeHelp'] = 'Ecrire ~b~/volume ~y~(0-10)~s~ pour changer le volume.\nExemple: ~b~/volume ~y~5~s~\n\nEcrire ~b~/tv ~y~youtube id~s~ pour changer la vidéo.\nExemple: ~b~/tv ~y~3hqjseATp4g~s~\n\nEcrire ~b~/tv_stop~s~ pour arrêter la vidéo\n\n~INPUT_CONTEXT~ Synchroniser le temps vidéo',
}