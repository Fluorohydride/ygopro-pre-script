--魔法妖精 バーガンディ
--Burgundy the Magical Elf
--Scripted by: CVen00/ToonyBirb with template provided by XGlitchy30
local s,id=GetID()
function s.initial_effect(c)
	--dmg
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DISCARD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.dmgcon)
	e1:SetOperation(s.dmgop)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(s.handescon)
	e2:SetTarget(s.handestg)
	e2:SetOperation(s.handesop)
	c:RegisterEffect(e2)
end
function s.dmgcon(e,tp,eg,ep,ev,re,r,rp)
	return re and eg:IsExists(s.dmgfilter,1,nil,1-tp)
end
function s.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(s.dmgfilter,nil,1-tp)
	Duel.Damage(1-tp,ct*400,REASON_EFFECT)
end
function s.dmgfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and c:IsReason(REASON_DISCARD)
end
function s.handescon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end
function s.handestg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function s.handesop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
