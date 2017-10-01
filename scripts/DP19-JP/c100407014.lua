--BM-4 ボムスパイダー
--BM-4 Bomb Spider
--Scripted by Eerie Code
function c100407014.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100407014,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c100407014.destg)
	e1:SetOperation(c100407014.desop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100407014,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100407014)
	e2:SetCondition(c100407014.damcon1)
	e2:SetTarget(c100407014.damtg)
	e2:SetOperation(c100407014.damop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c100407014.damcon2)
	c:RegisterEffect(e3)
end
function c100407014.desfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c100407014.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c100407014.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c100407014.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c100407014.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c100407014.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:GetPreviousControler()~=tp and tc:IsLocation(LOCATION_GRAVE)
		and bc:IsControler(tp) and bc:GetOriginalAttribute()==ATTRIBUTE_DARK and bc:GetOriginalRace()==RACE_MACHINE
end
function c100407014.damfilter1(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsReason(REASON_DESTROY) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()~=tp
end
function c100407014.damcon2(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsControler(tp) and rc:GetOriginalAttribute()==ATTRIBUTE_DARK
		and rc:GetOriginalRace()==RACE_MACHINE
		and eg:IsExists(c100407014.damfilter1,1,nil,tp)
end
function c100407014.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c100407014.damfilter2(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()~=tp
end
function c100407014.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c100407014.damfilter2,nil,tp)
	if g:GetCount()>0 then
		if g:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			g=g:Select(tp,1,1,nil)
		end
		Duel.Damage(1-tp,math.ceil(g:GetFirst():GetBaseAttack()/2),REASON_EFFECT)
	end
end
