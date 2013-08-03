"""Plugin to prevent pylint from erroring on hashlib imports"""
from logilab.astng import MANAGER
from logilab.astng.builder import ASTNGBuilder

def hashlib_transform(module):
    """Create a fake hashlib module with hash functions"""
    if module.name == 'hashlib':
        fake = ASTNGBuilder(MANAGER).string_build('''

class md5(object):
  def __init__(self, value): pass

  def update(self, message): pass
  def hexdigest(self):
    return u''

class sha1(object):
  def __init__(self, value): pass
  def hexdigest(self):
    return u''

class sha256(object):
  def __init__(self, value): pass
  def hexdigest(self):
    return u''

''')
        for hashfunc in ('sha1', 'sha256', 'md5'):
            module.locals[hashfunc] = fake.locals[hashfunc]

def register(linter):
    """called when loaded by pylint --load-plugins, register our tranformation
    function here
    """
    MANAGER.register_transformer(hashlib_transform)
