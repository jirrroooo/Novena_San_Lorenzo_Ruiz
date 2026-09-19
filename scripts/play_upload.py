#!/usr/bin/env python3
"""Upload an Android App Bundle to Google Play as a draft on several tracks.

The bundle is uploaded once inside a single Play "edit" and the same version
code is then attached to every requested track. Uploading the same bundle in
separate runs (one per track) fails because Play rejects a version code that
was already uploaded.

Usage:
  play_upload.py --service-account key.json --package com.example.app \
      --aab app.aab --tracks production alpha --release-name "1.2.3 (45)"

Track names: "production", "beta" (default open testing), "alpha" (default
closed testing), "internal", or the name of a custom closed-testing track.
"""

import argparse
import sys

from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

SCOPES = ["https://www.googleapis.com/auth/androidpublisher"]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--service-account", required=True)
    parser.add_argument("--package", required=True)
    parser.add_argument("--aab", required=True)
    parser.add_argument("--tracks", nargs="+", required=True)
    parser.add_argument("--release-name", required=True)
    args = parser.parse_args()

    credentials = service_account.Credentials.from_service_account_file(
        args.service_account, scopes=SCOPES
    )
    publisher = build("androidpublisher", "v3", credentials=credentials, cache_discovery=False)
    edits = publisher.edits()

    edit_id = edits.insert(packageName=args.package, body={}).execute()["id"]
    print(f"Opened edit {edit_id}")

    bundle = edits.bundles().upload(
        packageName=args.package,
        editId=edit_id,
        media_body=MediaFileUpload(args.aab, mimetype="application/octet-stream", resumable=True),
    ).execute()
    version_code = str(bundle["versionCode"])
    print(f"Uploaded bundle with version code {version_code}")

    for track in args.tracks:
        edits.tracks().update(
            packageName=args.package,
            editId=edit_id,
            track=track,
            body={
                "track": track,
                "releases": [
                    {
                        "name": args.release_name,
                        "versionCodes": [version_code],
                        # Draft: nothing is rolled out until it is reviewed and
                        # released manually in the Play Console.
                        "status": "draft",
                    }
                ],
            },
        ).execute()
        print(f"Assigned version {version_code} to '{track}' as a draft")

    edits.commit(packageName=args.package, editId=edit_id).execute()
    print("Edit committed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
