import type { I18nKeys } from '~/i18n/type.d.ts'

export interface Site
{
	title?: string
	description?: string | I18nKeys
	author?: string
	keywords?: string[]
	themeColor?: string
	favicon?: string
	lang?: string
}

export const site: Site = {
	title: 'Fluff Event Documents',
	description: {
		'en': 'Fluff Event association documents render in printable web pages.',
		'fr': 'Documents de l\'association Fluff Event rendus en pages web imprimables.',
	},
	author: 'Matiboux',
	themeColor: '#ffffff',
}
