<template>
    <div class="card">
        <div class="card-body">
            <h2>{{ $t('resource_card.resources') }}</h2>
            <p>{{ $t('resource_card.resources_desc') }}</p>
            <div class="d-flex flex-wrap gap-2 mt-4">
                <a class="btn btn-secondary" href="https://github.com/ClassicOldSong/Apollo/discussions" target="_blank">
                  <SimpleIcon icon="GitHub" :size="18" class="icon"></SimpleIcon>
                  {{ $t('resource_card.github_discussions') }}
                </a>
                <a class="btn btn-secondary" href="https://github.com/ClassicOldSong/Apollo/wiki" target="_blank">
                  <SimpleIcon icon="GitHub" :size="18" class="icon"></SimpleIcon>
                  {{ $t('resource_card.github_wiki') }}
                </a>
                <a class="btn btn-secondary" href="https://github.com/ClassicOldSong/Apollo/wiki/Stuttering-Clinic" target="_blank">
                  <SimpleIcon icon="GitHub" :size="18" class="icon"></SimpleIcon>
                  {{ $t('resource_card.github_stuttering_clinic') }}
                </a>
            </div>
        </div>
    </div>
    <!-- Legal -->
    <div class="card mt-4">
        <div class="card-body">
            <h2>{{ $t('resource_card.legal') }}</h2>
            <p>{{ $t('resource_card.legal_desc') }}</p>
            <div class="d-flex flex-wrap gap-2 mt-4">
                <a class="btn btn-danger" href="https://github.com/ClassicOldSong/Apollo/blob/master/LICENSE"
                    target="_blank">
                  <FileText :size="18" class="icon"></FileText>
                  {{ $t('resource_card.license') }}
                </a>
                <a class="btn btn-danger" href="https://github.com/ClassicOldSong/Apollo/blob/master/NOTICE"
                    target="_blank">
                  <AlertCircle :size="18" class="icon"></AlertCircle>
                  {{ $t('resource_card.third_party_notice') }}
                </a>
            </div>
        </div>
    </div>
</template>

<script>
import {
  AlertCircle,
  FileText,
} from '@lucide/vue'
import SimpleIcon from './SimpleIcon.vue'

export default {
  props: {
    // Accepted for compatibility with index.html; Apollo links to its own wiki rather than the
    // versioned Sunshine documentation, so the value is currently unused here.
    installedVersionNotStable: {
      type: Boolean,
      default: false
    }
  },
  components: {
    SimpleIcon,
    AlertCircle,
    FileText,
  },
}
</script>
