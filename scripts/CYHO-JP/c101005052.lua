--ゼロ・エクストラリンク
--Zero Extra Link
--Script by nekrozar
function c101005052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101005052.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetLabelObject(e1)
	e2:SetCondition(c101005052.tgcon)
	e2:SetOperation(c101005052.tgop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c101005052.atktg1)
	e3:SetValue(c101005052.atkval1)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101005052,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c101005052.atktg2)
	e4:SetOperation(c101005052.atkop2)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(c101005052.valcheck)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(101005052,0))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLED)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c101005052.descon)
	e6:SetTarget(c101005052.destg)
	e6:SetOperation(c101005052.desop)
	c:RegisterEffect(e6)
end
function c101005052.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetSequence()>4
end
function c101005052.filter(c,g)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and g:IsContains(c)
end
function c101005052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Group.CreateGroup()
	local lg=Duel.GetMatchingGroup(c101005052.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		tg:Merge(tc:GetMutualLinkedGroup())
	end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101005052.filter(chkc,tg) end
	if chk==0 then return Duel.IsExistingTarget(c101005052.filter,tp,LOCATION_MZONE,0,1,nil,tg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101005052.filter,tp,LOCATION_MZONE,0,1,1,nil,tg)
end
function c101005052.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c101005052.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
	if c:IsRelateToEffect(re) and tc:IsFaceup() and tc:IsRelateToEffect(re) then
		c:SetCardTarget(tc)
	end
end
function c101005052.atktg1(e,c)
	return e:GetHandler():IsHasCardTarget(c)
end
function c101005052.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101005052.atkval1(e,c)
	local atk=Duel.GetMatchingGroupCount(c101005052.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*800
	e:SetLabel(atk)
	return atk
end
function c101005052.matfilter(c,mc)
	return mc:IsHasCardTarget(c)
end
function c101005052.valcheck(e,c)
	if c:GetMaterial():IsExists(c101005052.matfilter,1,nil,e:GetHandler()) then
		c:RegisterFlagEffect(101005052,RESET_EVENT+0x4fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c101005052.cfilter(c,tp)
	return c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetFlagEffect(101005052)~=0
end
function c101005052.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101005052.cfilter,1,nil,tp) end
	Duel.SetTargetCard(eg)
end
function c101005052.atkop2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=e:GetLabelObject():GetLabel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c101005052.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasCardTarget(Duel.GetAttacker())
end
function c101005052.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c101005052.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
